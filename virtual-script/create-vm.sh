#! /bin/bash

ISO_PATH=""
OS_VARIANT=""
VM_NAME=""
RAM=""
CPUS=""
NET_BRIDGE_NAME=""
SIZE_DISK=""
DISK_PATH=""

getConfig () {
    read -p "enter iso path: " ISO_PATH
    read -p "enter os variant: " OS_VARIANT
    read -p "enter vm name: " VM_NAME
    read -p "enter allocated RAM: " RAM
    read -p "enter number of cpus: " CPUS
    #read -p "enter network bridge name: " NET_BRIDGE_NAME
    read -p "enter disk path: " DISK_PATH
    read -p "enter size of disk: " SIZE_DISK
}

createNetBridge () {

}

createVM () {
    virt-install \\
     --virt-type=kvm \\
     --name $VM_NAME \\
     --ram $RAM \\
     --vcpus=$CPUS \\
     --os-variant=$OS_VARIANT \\
     --cdrom=$ISO_PATH \\
     --network=bridge=$NET_BRIDGE_NAME,model=virtio \\
     --graphics vnc \\
     --disk path=$DISK_PATH/$VM_NAME.qcow2,size=$SIZE_DISK,bus=virtio,format=qcow2
}

getConfig
createVM