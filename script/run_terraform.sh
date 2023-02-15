#!/bin/bash

terraform_function () {
    path=$1
    mode=$2
    varfile=$3
    cd $path || exit
    if [[ -d $path/.terraform ]]
    then
        terraform init -reconfigure
    else
        terraform init
    fi
    if [ $mode == "create" ] && [ -n "$varfile" ]
    then
        terraform plan
        terraform apply -var-file=$varfile -auto-approve
    elif [ $mode == "create" ] && [ -z "$varfile" ]
    then
        terraform plan
        terraform apply -auto-approve
    else
        terraform destroy -auto-approve
    fi
}

# Get the absolution of path
abs_path_file_execute=$(realpath "$0")
abs_path_folder_root=$(dirname "$(dirname "$abs_path_file_execute")")
abs_path_folder_terraform_vm="$abs_path_folder_root/terraform/modules/vm/"
abs_path_folder_terraform_iam="$abs_path_folder_root/terraform/modules/iam/"
abs_path_folder_terraform_network="$abs_path_folder_root/terraform/modules/network/"
abs_path_folder_terraform_bucket="$abs_path_folder_root/terraform/modules/bucket/"


# Bash Menu Script Example
echo "---------MENU------------"
PS3='Please enter your choice: '
options=("Create IAM" "Create virtual machine" "Create bucket" "Create network" "Destroy IAM" "Destroy virtual machine" "Destroy bucket" "Destroy network" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Create IAM")
            terraform_function $abs_path_folder_terraform_iam "create" ""
        ;;
        "Create virtual machine")
            terraform_function $abs_path_folder_terraform_vm "create" ""
        ;;
        "Create bucket")
            terraform_function $abs_path_folder_terraform_bucket "create" "terraform.tfvars"
        ;;
        "Create network")
            terraform_function $abs_path_folder_terraform_network "create" ""
        ;;
        "Destroy IAM")
            terraform_function $abs_path_folder_terraform_iam "destroy" ""
        ;;
        "Destroy virtual machine")
            terraform_function $abs_path_folder_terraform_vm "destroy" ""
        ;;
        "Destroy bucket")
            terraform_function $abs_path_folder_terraform_bucket "destroy" ""
        ;;
        "Destroy network")
            terraform_function $abs_path_folder_terraform_network "destroy" ""
        ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
