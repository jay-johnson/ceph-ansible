#!/bin/bash

found_colors="./tools/bash_colors.sh"
up_found_colors="../tools/bash_colors.sh"
if [[ "${DISABLE_COLORS}" == "" ]] && [[ "${found_colors}" != "" ]] && [[ -e ${found_colors} ]]; then
    . ${found_colors}
elif [[ "${DISABLE_COLORS}" == "" ]] && [[ "${up_found_colors}" != "" ]] && [[ -e ${up_found_colors} ]]; then
    . ${up_found_colors}
fi

./kvm-build-images.sh
./kvm-attach-images.sh

source /opt/venv/bin/activate
user="ceph"

anmt "--------------------------------------"
anmt "starting ceph-ansible playbook:"
echo "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory_file site.yml.sample --user ${user} -vvvv"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory_file site.yml.sample --user ${user} -vvvv
anmt "--------------------------------------"
