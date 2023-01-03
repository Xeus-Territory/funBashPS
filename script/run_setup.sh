#!/bin/bash
source try_catch.sh
export docker_err=100
export syspath_err=101

# Generate the ssl certificate
# Write a Powershell script and a Bash script that generate a self-signed SSL certificate
DOMAIN="$1"
if [ -z "$DOMAIN" ]; then
  echo "Usage: $(basename $0) <domain>"
  exit 11
fi

fail_if_error() {
  [ $1 != 0 ] && {
    unset PASSPHRASE
    exit 10
  }
}

# Generate a passphrase
export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo)

# Certificate details; replace items in angle brackets with your own info
subj="
C=VN
ST=blah
O=Blah
localityName=vietnam
commonName=$DOMAIN
organizationalUnitName=Blah
emailAddress=admin@example.com
"

# Generate the server private key
openssl genrsa -des3 -out $DOMAIN.key -passout env:PASSPHRASE 2048
fail_if_error $?

# Generate the CSR
openssl req \
    -new \
    -batch \
    -subj "$(echo -n "$subj" | tr "\n" "/")" \
    -key $DOMAIN.key \
    -out $DOMAIN.csr \
    -passin env:PASSPHRASE
fail_if_error $?
cp $DOMAIN.key $DOMAIN.key.org
fail_if_error $?

# Strip the password so we don't have to type it every time we restart Apache
openssl rsa -in $DOMAIN.key.org -out $DOMAIN.key -passin env:PASSPHRASE
fail_if_error $?

# Generate the cert (good for 10 years)
openssl x509 -req -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt
fail_if_error $?

try
(
  # Remove docker ps & image
  docker rm -f "$(docker ps -aq)" || true
  docker rmi nginx_alb:latest || true
  docker rmi "$(docker image list | grep webpage)" || true

  # Remove the network
  docker network rm "$(docker network list | grep my_network)" || true

  # Move on the src folder and after that execute the docker script
  # Get the absolution of path
  abs_path_file_execute=$(readlink -f "${BASH_SOURCE:-$0}")
  abs_path_folder_script=$(dirname "$abs_path_file_execute")
  abs_path_folder_root=$(dirname "$(dirname "$abs_path_file_execute")")
  abs_path_folder_docker="$abs_path_folder_root""/docker/"
  abs_path_folder_src="$abs_path_folder_root""/src/"
  mv $(ls $abs_path_folder_script --ignore=run_setup.sh) "$abs_path_folder_docker/conf/" || throw $syspath_err
  # cp -r "$PWD"/../src/ "$PWD"/../docker/
  cp -r "$abs_path_folder_src" "$abs_path_folder_docker" || throw $syspath_err
  # cd "$PWD"/../docker/ || exit
  cd "$abs_path_folder_docker" || throw $syspath_err

  # Pull and create each website with specified name
  docker build -t webpage8001:latest -f Dockerfile.web . || throw $docker_err
  docker build -t webpage8002:latest -f Dockerfile.web . || throw $docker_err
  docker build -t webpage8003:latest -f Dockerfile.web . || throw $docker_err
  docker build -t webpage8004:latest -f Dockerfile.web . || throw $docker_err

  rm -rf src/ || throwErrors

  docker build -t nginx_alb:latest -f Dockerfile.nginx . || throw $docker_err

  cd "$abs_path_folder_docker/conf/" || throw $syspath_err
  rm $(ls --ignore=nginx.conf) || throwErrors $syspath_err
  cd "$abs_path_folder_root" || throw $syspath_err

  docker-compose up -d || throw "Unable run docker-compose"
)
catch || {
  case $ex_code in
    $docker_err)
      echo "Something went wrong during run docker-command for building"
    ;;
    $syspath_err)
      echo "something went wrong with do in with bash file"
    ;;
    *)
      echo "Unhandled error"
      throw $ex_code
    ;;
    esac
}
