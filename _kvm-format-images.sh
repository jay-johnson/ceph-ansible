#!/bin/bash

# use the bash_colors.sh file
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

# https://www.cyberciti.biz/faq/how-to-add-disk-image-to-kvm-virtual-machine-with-virsh-command/
nodes="c1.example.com c2.example.com c3.example.com"

function check_mounts() {
    anmt "--------------------------------"
    anmt "checking mounted ${dev_path} paths on the cluster vms"
    for node in $nodes; do
        anmt "${node} fdisk -l"
        ssh root@${node} "fdisk -l"
        anmt "--------------------------------"
    done
}

function delete_partitions_and_reformat_disks() {
    dev_path=$1

    anmt "--------------------------------"
    anmt "deleting ${nodes} devices and reformatting ${dev_path} block partitions with xfs"

    for node in $nodes; do

        # unmount device if mounted
        anmt "${node} - ${dev_path} umount"
        ssh root@${node} "umount ${dev_path}2"
        ssh root@${node} "umount ${dev_path}1"
        ssh root@${node} "umount ${dev_path}"

        # delete partitions
        anmt "${node} - deleting partitions"
        ssh root@${node} "parted -s ${dev_path} rm 1"
        ssh root@${node} "parted -s ${dev_path} rm 1"

        # good "${node} - using parted to partition ${dev_path}"
        # https://unix.stackexchange.com/questions/38164/create-partition-aligned-using-parted/49274#49274
        # echo "ssh root@${node} "parted -s -a optimal ${dev_path} mkpart ceph 0% 100%""
        # ssh root@${node} "parted -s -a optimal ${dev_path} mkpart ceph 0% 100%"
        # sleep 2

        # anmt "${node} - checking ${dev_path} partitions"
        # check_if_partitioned=$(ssh root@${node} "parted -s ${dev_path} print | grep -A 10 Number | grep -E 'MB|GB' | wc -l")
        # if [[ "${check_if_partitioned}" != "1" ]]; then
        #    err "Failed automated parted partitioning - please manually delete ${dev_path} partitions on ${node} with the commands and retry: "
        #    ssh root@${node} "parted ${dev_path} print"
        #    anmt "ssh root@${node}"
        #    anmt "parted ${dev_path}"
        #    exit 1
        # fi

        # ceph recommends xfs filesystems
        # http://docs.ceph.com/docs/jewel/rados/configuration/filesystem-recommendations/
        # anmt "${node} - formatting ${dev_path}1 as xfs"
        # ssh root@${node} "mkfs.xfs -f ${dev_path}1"

        # anmt "${node} - formatting ${dev_path}2 as xfs"
        # ssh root@${node} "mkfs.xfs -f ${dev_path}2"

        # anmt "${node} - removing previous mountpoint if exists: /var/lib/ceph"
        # ssh root@${node} "rm -rf /var/lib/ceph >> /dev/null"

        # anmt "${node} - creating ${dev_path}1 mountpoint: /var/lib/ceph"
        # ssh root@${node} "mkdir -p -m 775 /var/lib/ceph >> /dev/null"

        # ssh root@${node} "umount ${dev_path}1"
        # anmt "${node} - mounting ${dev_path}1 to /var/lib/ceph"
        # ssh root@${node} "mount ${dev_path}1 /var/lib/ceph"

        # check_disk_filesystem=$(ssh root@${node} "df -Th /var/lib/ceph | grep vdb | grep xfs | wc -l")
        # if [[ "${check_disk_filesystem}" == "0" ]]; then
        #     err "Failed to mount ${node}:${dev_path}1 as xfs filesystem to /var/lib/ceph"
        #     anmt "Please fix this node and retry:"
        #     anmt "ssh root@${node}"
        # fi

        # test_exists=$(ssh root@${node} "cat /etc/fstab | grep vdb1 | grep xfs | wc -l")
        # if [[ "${test_exists}" == "0" ]]; then
        #     anmt "adding ${dev_path}1 to /etc/fstab"
        #     ssh root@${node} "echo \"${dev_path}1 /var/lib/ceph  xfs     defaults    0 0\" >> /etc/fstab"
        # fi

        anmt "${node} - checking mounts"
        ssh root@${node} "fdisk -l ${dev_path}"
        anmt "--------------------------------------------"
    done
}

devices_per_vm="/dev/vdb /dev/vdc"
for d in ${devices_per_vm}; do
    delete_partitions_and_reformat_disks ${d}
done

check_mounts

good "done"
exit 0
