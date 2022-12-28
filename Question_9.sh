read -r -p "which mode do you want to apply ssh: " ssh_mode

if [[ $ssh_mode = "enable" || $ssh_mode = "Enable" ]]
then
    sudo systemctl start ssh
    echo "SSH is enable"
fi
if [[ $ssh_mode = "disable" || $ssh_mode = "Disable" ]]
then
    sudo systemctl stop ssh
    echo "SSH is disable"
fi
