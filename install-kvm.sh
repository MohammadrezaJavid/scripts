#!/bin/bash

# default value for VT is -1
# if VT == 1 your system support Virtualization Technology 
# if VT == 0 your system is not support Virtualization Technology 
let VT=-1

installKvm () {
    dnf update &> /dev/null
    dnf install qemu-kvm &> /dev/null
    dnf install libvirt &> /dev/null
    dnf install libvirt-python &> /dev/null
    dnf install libguestfs-tools &> /dev/null
    dnf install python-virtinst &> /dev/null

    systemctl enable libvirtd
    echo
    systemctl start libvirtd

    echo "KVM Installed successfully"
}

checkVmxSvm () {
    let count
    let result=0

    # If the output has the vmx or svm flags,
    # then Intel or AMD CPU host is capable of
    # running hardware virtualization.

    count=$(cat /proc/cpuinfo | grep -ci "vmx")  # check for Intel
    if [ $count != 0 ]
    then
        echo "vmx is OK."
        result=1
    fi

    count=$(cat /proc/cpuinfo | grep -ci "svm")  # check for AMD
    if [ $count != 0 ]
    then
        echo "svm is OK."
        result=1
    fi
}

checkVirtualizationTechnology () {
    checkVmxSvm

    if [ $result -eq 1 ]
    then
        VT=1
    fi

    if [ $VT -eq 1 ]
    then
        echo "your system support Virtualization Technology."
        installKvm
    else
        echo "your system is not support Virtualization Technology"
    fi
}

checkVirtualizationTechnology