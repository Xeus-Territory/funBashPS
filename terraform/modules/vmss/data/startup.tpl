#!/bin/bash
sudo su 
apt update
apt install docker-compose -y
apt install pass gnupg2 -y
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --identity 
az acr login --name ${containerRegistry_main}
az storage blob download --auth-mode login --account-name ${storageAccount_web} -c ${storageContainer_web} -n ${storageBlob_web}  > docker-compose.yaml
docker-compose up -d