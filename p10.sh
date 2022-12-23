#!/bin/bash

# Write a Powershell script and a Bash script that generate a self-signed SSL certificate

read -p "What is the name of the domain u want to generate a self-signed SSL certificate: " domain
password=dummypassword

#Generate a key
openssl genrsa -des3 -passout pass:$password -out $domain.key 2048 -noout

#Remove passphrase from the key. Comment the line out to keep the passphrase
echo "Removing passphrase from key"
openssl rsa -in $domain.key -passin pass:$password -out $domain.key

echo
echo "---------------------------"
echo "-----Below is your Key-----"
echo "---------------------------"
echo
cat $domain.key