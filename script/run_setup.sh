#!/bin/bash
export docker_err=100
export syspath_err=101

# Get the absolution of path
abs_path_file_execute=$(realpath "$0")
abs_path_folder_script=$(dirname "$abs_path_file_execute")
abs_path_folder_root=$(dirname "$(dirname "$abs_path_file_execute")")
abs_path_folder_docker="$abs_path_folder_root""/docker/"
abs_path_folder_src="$abs_path_folder_root""/src/"
abs_path_folder_conf="$abs_path_folder_docker/conf"

source "$abs_path_folder_script/try_catch.sh"

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
openssl genrsa -des3 -out "$abs_path_folder_conf/$DOMAIN.key" -passout env:PASSPHRASE 2048
fail_if_error $?

# Generate the CSR
openssl req \
    -new \
    -batch \
    -subj "$(echo -n "$subj" | tr "\n" "/")" \
    -key "$abs_path_folder_conf/$DOMAIN.key" \
    -out "$abs_path_folder_conf/$DOMAIN.csr" \
    -passin env:PASSPHRASE
fail_if_error $?
cp "$abs_path_folder_conf/$DOMAIN.key" "$abs_path_folder_conf/$DOMAIN.key.org"
fail_if_error $?

# Strip the password so we don't have to type it every time we restart Apache
openssl rsa -in "$abs_path_folder_conf/$DOMAIN.key.org" -out "$abs_path_folder_conf/$DOMAIN.key" -passin env:PASSPHRASE
fail_if_error $?

# Generate the cert (good for 10 years)
openssl x509 -req -days 3650 -in "$abs_path_folder_conf/$DOMAIN.csr" -signkey "$abs_path_folder_conf/$DOMAIN.key" -out "$abs_path_folder_conf/$DOMAIN.crt"
fail_if_error $?

# Remove docker ps & image
docker stop "$(docker ps -a)" || true
docker rm -f "$(docker ps -aq)" || true
docker rmi nginx_alb:latest || true
docker rmi "$(docker image list | grep webpage)" || true

# Remove the network
docker network rm "$(docker network list | grep my_network)" || true

# Move on the src folder and after that execute the docker script
# Solution 1: Using the mv but not working if don't move absolute path
# mv $(ls $abs_path_folder_script --ignore=run_setup.sh --ignore=try_catch.sh) "$abs_path_folder_docker/conf/" || throw $syspath_err

# Solution 2: Move with name of Domain --> it work good 
# mv "$abs_path_folder_script/$DOMAIN.crt" "$abs_path_folder_docker/conf" || throw $syspath_err
# mv "$abs_path_folder_script/$DOMAIN.key" "$abs_path_folder_docker/conf" || throw $syspath_err
# mv "$abs_path_folder_script/$DOMAIN.csr" "$abs_path_folder_docker/conf" || throw $syspath_err
# mv "$abs_path_folder_script/$DOMAIN.key.org" "$abs_path_folder_docker/conf" || throw $syspath_err

# Solution 3: Create into conf and do not erase smt

# cp -r "$PWD"/../src/ "$PWD"/../docker/
cp -r "$abs_path_folder_src" "$abs_path_folder_docker" || throw $syspath_err
# cd "$PWD"/../docker/ || exit
cd "$abs_path_folder_docker" || throw $syspath_err

# Pull and create each website with specified name
docker build -t webpage8001:latest -f Dockerfile.web . || throw $docker_err
docker build -t webpage8002:latest -f Dockerfile.web . || throw $docker_err
docker build -t webpage8003:latest -f Dockerfile.web . || throw $docker_err
docker build -t webpage8004:latest -f Dockerfile.web . || throw $docker_err

rm -rf src/ || throw $syspath_err

docker build -t nginx_alb:latest --build-arg domain_key=$DOMAIN.key --build-arg domain_crt=$DOMAIN.crt -f Dockerfile.nginx . || throw $docker_err

cd "$abs_path_folder_docker/conf/" || throw $syspath_err
rm $(ls --ignore=nginx.conf) || throwErrors $syspath_err
cd "$abs_path_folder_root" || throw $syspath_err

docker-compose up -d || true
