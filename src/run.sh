
#!/bin/bash
################################################################################
# Description:
#    Script 'start point' that start a Ansible playbook to create or destroy an infra in AWS
#
# Dependencies:
#    ENV:
#     - AWS_ACCESS_KEY_ID: AWS access_key
#     - AWS_SECRET_ACCESS_KEY: AWS secret key
#     - UPE_SSH_PUBLIC_KEY: ssh public key
#
#   PACKAGES:
#     - docker: see [https://docs.docker.com/engine/install/ubuntu/]
#
# Parameters: [MANDATORY]
#   --create-infra: Param to create infra in AWS
#   --destroy-infra: Param to destroy infra in AWS
#
# Use:
#   i.e: ./run.sh --create-infra
#   i.e: ./run.sh --destroy-infra
#
################################################################################
# Author: Frank Junior frnakcbjunior@gmail.com
# Date: 19/08/2021
# Version: 1
################################################################################

parameter="$1"

mode=""
docker_image="upe/iac_example"

SUCCESS=0
ERROR=1

# ============================================
# Help Message
# ============================================
help_message(){
    echo " Description:"
    echo "    Script 'start point' that start a Ansible playbook to create or destroy an infra in AWS"
    echo
    echo " Dependencies:"
    echo "    ENV:"
    echo "     - AWS_ACCESS_KEY_ID: AWS access_key"
    echo "     - AWS_SECRET_ACCESS_KEY: AWS secret key"
    echo "     - UPE_SSH_PUBLIC_KEY: ssh public key"
    echo
    echo "   PACKAGES:"
    echo "     - docker: see [https://docs.docker.com/engine/install/ubuntu/]"
    echo
    echo " Parameters: [MANDATORY]"
    echo "   --create-infra: Param to create infra in AWS"
    echo "   --destroy-infra: Param to destroy infra in AWS"
    echo
    echo " Use:"
    echo "   i.e: ./run.sh --create-infra"
    echo "   i.e: ./run.sh --destroy-infra"
    echo
}

# ============================================
# Auxiliar function to create a .env with AWS and SSH_KEY env vars
# ============================================
generate_env_file(){
    key_file="ec2_ssh_key.pem"
    env_file_name=".env"

    # params:
    #-t rsa:                kind of key to create
    # -f ec2_ssh_key.pem:   name of key file
    # -q:                   silent
    # -N "":                new passphrase blank
    ssh-keygen -t rsa -f "$key_file" -q -N ""

    ssh_public_key=$(cat "${key_file}.pub")

    env_file_content="
    export AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_HERE>
    export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_KEY_HERE>
    export UPE_SSH_PUBLIC_KEY=$ssh_public_key
    "

    echo "$env_file_content" > "$env_file_name"
    rm -rf "${key_file}.pub"
}

validation(){
    if ! env | grep -q "AWS_ACCESS_KEY_ID";then
        echo "Ops, set the AWS env vars fisrt:"
        echo "export AWS_ACCESS_KEY_ID="
        echo "export AWS_SECRET_ACCESS_KEY="
        echo
        echo "or, run:"
        echo "./run --generate-env-file"
        exit "$SUCCESS"
    fi

    if ! env | grep -q "UPE_SSH_PUBLIC_KEY";then
        echo "Ops, set an env with ssh public key:"
        echo "export UPE_SSH_PUBLIC_KEY="
        echo
        echo "or, run:"
        echo "./run --generate-env-file"
        exit "$SUCCESS"
    fi
}

# ============================================
# MAIN
# ============================================


case "$parameter" in
    # mensagem de help
    -h | --help)
        help_message
        exit "$SUCCESS"
    ;;
    --create-infra)
        validation
        mode="create-infra"
    ;;
    --destroy-infra)
        validation
        mode="destroy-infra"
    ;;
    --generate-env-file)
        generate_env_file
        echo ".env file created with success."
        echo "run:"
        echo "source .env"
        exit "$SUCCESS"
    ;;
    *)
        echo "Invalid option: $parameter"
        echo "see: ./run.sh --help"
        exit "$ERROR"
    ;;
esac

# check if docker image exist, if not, build
if [ "$mode" = "create-infra" ];then
    if ! docker images "$docker_image" | grep -q -v "REPOSITORY" ; then
        docker build -t "$docker_image" .
    fi
fi

# Run the Ansible playbook
docker run -it \
--env "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
--env "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
--env "UPE_SSH_PUBLIC_KEY=${UPE_SSH_PUBLIC_KEY}" \
"$docker_image" ansible-playbook playbook-main.yaml --tags "$mode"

# if parameter is 'destroy-infra', clean the docker image
if [ "$mode" = "destroy-infra" ];then
    docker_image_id=$(docker images "$docker_image" -q)
    docker_container_id=$(docker container ls -a | grep "$docker_image" | awk '{print $1}' | xargs)

    if [ "$docker_container_id" != "" ];then
        docker rm $docker_container_id
    fi

    if [ "$docker_image_id" != "" ];then
        docker rmi "$docker_image_id"
    fi
fi
