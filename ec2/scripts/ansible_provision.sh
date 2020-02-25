#!/usr/bin/env bash

set -e

ROOT_PATH=$(pwd)

if [[ "${ROOT_PATH}" =~ "scripts" ]];
 then
    ROOT_PATH="${ROOT_PATH}/.."
fi

echo "Defined path - ${ROOT_PATH}"

if [[ -n $1 ]]; then
    COMMAND=$1
    echo $1
fi

for i in "$@"
    do
        case ${i} in
            --prefix=*)
            PREFIX="${i#*=}"
            echo "Defined command - ${COMMAND}"
            shift # past argument=value
            ;;
            --profile=*)
            PROFILE="${i#*=}"
            echo "Defined prefix - ${PREFIX} and profile - ${PROFILE}"
            shift # past argument=value
            ;;
        esac
    done

source ${ROOT_PATH}/profiles/${PROFILE}/cred.txt
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
export ANSIBLE_CONFIG="${ROOT_PATH}/ansible/ansible.cfg"
export EC2_INI_PATH="${ROOT_PATH}/ansible/.aws.ini"

case ${COMMAND} in
    'help')
        echo "Helpdesk"
        shift
        ;;
    'validate')
        cd ${ROOT_PATH}/ansible
        echo "Running tests"

        shift
        ;;
    'bastion')
        cd ${ROOT_PATH}/ansible

        PROVISION_USER="ubuntu"

        ansible-playbook bastion.yml \
            --private-key ${ROOT_PATH}/profiles/${PROFILE}/ssh/test \
            -i aws.py \
            -u ${PROVISION_USER} \
            -e "profile=${PROFILE}" \
            -e "prefix=${PREFIX}" \
            -e "host=*bastion*" \
            -e "project_dir_root=${ROOT_PATH}"

        shift
        ;;
    'database')
        cd ${ROOT_PATH}/ansible
        shift
        ;;
    'proxy')
        cd ${ROOT_PATH}/ansible
        shift
        ;;
    'app')
        cd ${ROOT_PATH}/ansible
        shift
        ;;
    'clone-repo')
        cd ${ROOT_PATH}/ansible
        shift
        ;;
    'instance')
        cd ${ROOT_PATH}/ansible

        echo $(${ROOT_PATH}/ansible/aws.py --list) >> ${ROOT_PATH}/ansible/test.json
        cat ${ROOT_PATH}/ansible/test.json

        shift
        ;;
    *)
        echo "Not specified an action!"
        exit 1
esac


