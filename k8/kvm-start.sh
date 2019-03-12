#!/bin/bash

if [[ -e ./tools/bash_colors.sh ]]; then
    source tools/bash_colors.sh
fi

anmt "--------------------------------------"
vms="c1 c2 c3"
anmt "starting vms: ${vms}"
for vm in $vms; do
    running_test=$(virsh list | grep ${vm} | grep running | wc -l)
    if [[ "${running_test}" == "0" ]]; then
        inf "setting autostart for vm with: virsh autostart ${vm}"
        virsh autostart ${vm}
        inf "starting vm: virsh start ${vm}"
        virsh start ${vm}
    else
        inf " - ${vm} already runnning"
    fi
done

echo ""
good "checking vms:"
virsh list | grep -E $(echo ${vms} | sed -e 's/ /|/g')
echo ""

anmt "--------------------------------------"
