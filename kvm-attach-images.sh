#!/bin/bash

found_colors="./tools/bash_colors.sh"
up_found_colors="../tools/bash_colors.sh"
if [[ "${DISABLE_COLORS}" == "" ]] && [[ "${found_colors}" != "" ]] && [[ -e ${found_colors} ]]; then
    . ${found_colors}
elif [[ "${DISABLE_COLORS}" == "" ]] && [[ "${up_found_colors}" != "" ]] && [[ -e ${up_found_colors} ]]; then
    . ${up_found_colors}
fi

image_dir="/cephdata"
size="100G"

if [[ ${1} != "" ]]; then
    image_dir=${1}
fi

if [[ ${2} != "" ]]; then
    size=${2}
fi

if [[ ! -e ${image_dir} ]]; then
    sudo mkdir -p -m 775 ${image_dir}
fi

nodes="c1 c2 c3 c1b c2b c3b"
for node in $nodes; do
    node_dir=${image_dir}/${node}
    if [[ ! -e ${node_dir} ]]; then
        sudo mkdir -p -m 775 ${node_dir}
    fi
    image_name="k8-centos-${node}"
    image_path="${node_dir}/${image_name}"
    if [[ ! -e ${image_path} ]]; then
        err "missing hdd image at: ${image_path} size: ${size}"
        err "please generate them manually or with the ./kvm-build-images.sh script"
        exit 1
    else
        if [[ "${node}" == "c1b" ]] || [[ "${node}" == "c2b" ]] || [[ "${node}" == "c3b" ]]; then
            name_of_vm=$(echo "${node}" | sed -e 's/b//g')
            anmt "attaching image: ${image_path} to ${name_of_vm} with:"
            echo "virsh attach-disk ${name_of_vm} \
                --source ${image_path} \
                --subdriver qcow2 \
                --target vdc --persistent"
            virsh attach-disk ${name_of_vm} \
                --source ${image_path} \
                --subdriver qcow2 \
                --target vdc \
                --persistent
        else
            anmt "attaching image: ${image_path} to ${node} with:"
            echo "virsh attach-disk ${node} \
                --source ${image_path} \
                --subdriver qcow2 \
                --target vdb --persistent"
            virsh attach-disk ${node} \
                --source ${image_path} \
                --subdriver qcow2 \
                --target vdb \
                --persistent
        fi
    fi
done

good "done"
exit 0
