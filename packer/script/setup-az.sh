#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install pass gnupg2 -y
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash