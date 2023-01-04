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

# Bash Menu Script Example
echo "---------MENU------------"
PS3='Please enter your choice: '
options=("Setup container" "Destroy container" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Setup container")
            # -------------------------- GENERATE SELF_SIGN SSL CERTIFICATE --------------------------
            # Go to docker/conf 
            cd $abs_path_folder_conf

            # Check input with domain
            read -p "Input domain you want to create with container: " DOMAIN
            if [ -z "$DOMAIN" ]; then
              echo "Usage: $(basename $0) with <domain>"
              exit 11
            fi

            # Check Error
            fail_if_error() {
              [ $1 != 0 ] && {
                unset PASSPHRASE
                exit 10
              }
            }

            # Generate a passphrase to create Password random
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
            openssl genrsa -des3 -out "$DOMAIN.key" -passout env:PASSPHRASE 2048
            fail_if_error $?

            # Generate the CSR
            openssl req \
                -new \
                -batch \
                -subj "$(echo -n "$subj" | tr "\n" "/")" \
                -key "$DOMAIN.key" \
                -out "$DOMAIN.csr" \
                -passin env:PASSPHRASE
            fail_if_error $?
            cp "$DOMAIN.key" "$DOMAIN.key.org"
            fail_if_error $?

            # Strip the password so we don't have to type it every time we restart Apache
            openssl rsa -in "$DOMAIN.key.org" -out "$DOMAIN.key" -passin env:PASSPHRASE
            fail_if_error $?

            # Generate the Certificate (good for 10 years)
            openssl x509 -req -days 3650 -in "$DOMAIN.csr" -signkey "$DOMAIN.key" -out "$DOMAIN.crt"
            fail_if_error $?

            # Go out docker/conf
            cd $abs_path_folder_root

            # -------------------------- CREATE IMAGE --------------------------
            # Get path of function try/catch to catch ERROR
            source "$abs_path_folder_script/try_catch.sh"

            # Go to docker/
            cd "$abs_path_folder_docker" || throw $syspath_err

            # Copy src/ into docker/
            cp -r "$abs_path_folder_src" . || throw $syspath_err

            # Create WEB images with specified name
            docker build -t webpage8001:latest -f Dockerfile.web . || throw $docker_err
            docker build -t webpage8002:latest -f Dockerfile.web . || throw $docker_err
            docker build -t webpage8003:latest -f Dockerfile.web . || throw $docker_err
            docker build -t webpage8004:latest -f Dockerfile.web . || throw $docker_err

            # Remove docker/src/
            rm -rf src/ || throw $syspath_err

            # Create NGINX image 
            docker build -t nginx_alb:latest --build-arg domain_key=$DOMAIN.key --build-arg domain_crt=$DOMAIN.crt -f Dockerfile.nginx . || throw $docker_err

            # Go to docker/conf to delete SSL after we create IMAGE
            cd "$abs_path_folder_conf" || throw $syspath_err
            rm $(ls --ignore=nginx.conf) || throwErrors $syspath_err

            # Go out docker/conf
            cd "$abs_path_folder_root" || throw $syspath_err


            # -------------------------- CREATE CONTAINER --------------------------
            docker-compose up -d || true
            ;;
        "Destroy container")
            # Remove container & image & network
            # docker kill "$(docker ps -a | awk {'print$1'})" || true
            docker kill $(docker ps -aq) ||  true 
            docker container prune --force 
            docker rmi nginx_alb:latest || true
            docker rmi $(docker image list | grep webpage | awk {'print$1'}) || true 
            docker network rm $(docker network list | grep my_network | awk {'print$1'}) || true
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
