#!/bin/bash

# Get the absolution of path
abs_path_file_execute=$(realpath "$0")
abs_path_folder_script=$(dirname "$abs_path_file_execute")
abs_path_folder_root=$(dirname "$(dirname "$abs_path_file_execute")")
abs_path_folder_kubernetes="$abs_path_folder_root""/kubernetes/"


 Bash Menu Script Example
echo "---------MENU------------"
PS3='Please enter your choice: '
options=("Create App 1" "Create App 2" "Create App 3" "Create App 4" "Create Nginx" "Create Ingress" )
select opt in "${options[@]}"
do
    case $opt in
        "Create App 1")
            cd $abs_path_folder_kubernetes/app1
            kubectl apply -f deployment.yaml
            kubectl apply -f service.yaml
        ;;
        "Create App 2")
            terraform_function $abs_path_folder_terraform_vm "create" ""
        ;;
        "Create App 3")
            terraform_function $abs_path_folder_terraform_bucket "create" "terraform.tfvars"
        ;;
        "Create App 4")
            terraform_function $abs_path_folder_terraform_network "create" ""
        ;;
        "Create Ngixn")
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
