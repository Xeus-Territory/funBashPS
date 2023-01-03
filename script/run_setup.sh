#!/bin/bash

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

# Remove docker ps & image
docker rm -f "$(docker ps -aq)"
docker rmi nginx_alb:latest
docker rmi "$(docker image list | grep webpage)"

# Remove the network
docker network rm "$(docker network list | grep my_network)"

# Move on the src folder and after that execute the docker script
mv $(ls --ignore=run_setup.sh) "$PWD"/../docker/conf/
cp -r "$PWD"/../src/ "$PWD"/../docker/
cd "$PWD"/../docker/ || exit

# Pull and create each website with specified name
docker build -t webpage8001:latest -f Dockerfile.web .
docker build -t webpage8002:latest -f Dockerfile.web .
docker build -t webpage8003:latest -f Dockerfile.web .
docker build -t webpage8004:latest -f Dockerfile.web .

rm -rf src/

docker build -t nginx_alb:latest -f Dockerfile.nginx .
cd "conf/" || exit
rm $(ls --ignore=nginx.conf)
cd .. || exit
cd .. || exit

docker-compose up -d

# # Docker run with specified name and bind port to local machine

# docker run -d --name webpage8001 -p 8001:3000 webpage8001:latest
# docker run -d --name webpage8002 -p 8002:3000 webpage8002:latest
# docker run -d --name webpage8003 -p 8003:3000 webpage8003:latest
# docker run -d --name webpage8004 -p 8004:3000 webpage8004:latest
