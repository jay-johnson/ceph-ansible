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
        anmt "creating hdd image at: ${image_path} size: ${size}"
        anmt "qemu-img create -f qcow2 ${image_path} ${size}"
        if [[ "${node}" == "c1b" ]] || [[ "${node}" == "c2b" ]] || [[ "${node}" == "c3b" ]]; then
            sudo qemu-img create -f qcow2 ${image_path} 30G
        else 
            sudo qemu-img create -f qcow2 ${image_path} ${size}
        fi
    else
        good " - already have image: ${image_path}"
        ls -lrth ${image_path}
    fi
done

good "done"
exit 0
