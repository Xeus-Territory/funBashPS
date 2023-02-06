#!/bin/bash

apt update && apt upgrade
apt install pass gnupg2 -y
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --identity
curl https://vstsagentpackage.azureedge.net/agent/2.214.1/vsts-agent-linux-x64-2.214.1.tar.gz
mkdir myagent
cd myagent || exit
tar zxvf ~/Downloads/vsts-agent-linux-x64-2.214.1.tar.gz
./config.sh --unattended --url ${url} --auth ${auth} --token ${token} --pool ${pool} --agent ${agent} --work ${workdir}
./run.sh
