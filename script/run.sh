#!/bin/bash

big_folder=$(dirname $(dirname $(realpath "$0")))

# ----------- CREATE CERTIFICATE ------------
cd $big_folder/docker/conf
DOMAIN="$1"
if [ -z "$DOMAIN" ]; then
  echo "Usage: $(basename $0) with <domain>"
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



# ----------- CREATE IMAGE ------------
cd $big_folder/docker

cp -r $big_folder/src/ 

# build 4 image WEB by dockerfile
docker build -t website:1 -f Dockerfile.web .
docker build -t website:2 -f Dockerfile.web .
docker build -t website:3 -f Dockerfile.web .
docker build -t website:4 -f Dockerfile.web .

# remove folder /src
rm -rf src/

# build image NGINX by dockerfile 
docker build -t nginx:server -f Dockerfile.nginx .

rm conf/$DOMAIN.*
 

# ---------- CREATE CONTAINER ----------------
cd $big_folder/script/
docker-compose up --detach




