#!/bin/bash

DNF=$(which dnf)
APT=$(whick apt-get)

install-run-resolvconf-service () {

    PACKAGE="resolvconf"
    DNF_PACKAGE_NAME="systemd-resolved"
    DEB_PACKAGE_NAME="resolvconf.service"

    if [[ ! -z $DNF ]]; then

        # update system
        echo -e "[$(date)] update log: " >> ./err.log
        dnf update 2>> ./err.log

        echo -e "\n\n"

        # install package
        echo -e "[$(date)] install log: " >> ./err.log
        dnf install $DNF_PACKAGE_NAME 2>> ./err.log

        # enable and start and check is active systemd-resolved.service
        systemctl enable systemd-resolved.service
        systemctl start systemd-resolved.service
        echo -e "\nresolved service is $(systemctl is-active systemd-resolved.service)\n"

    elif [[ ! -z $APT ]]; then

        # update system
        echo -e "[$(date)] update log: " >> ./err.log
        apt-get update 2>> /dev/null

        echo -e "\n\n"

        # install package
        echo -e "[$(date)] install log: " >> ./err.log
        apt-get install $DEB_PACKAGE_NAME 2>> ./err.log

        # enable and start and check is active resolvconf.service
        systemctl enable resolvconf.service
        systemctl start resolvconf.service
        echo -e "\nresolved service is $(systemctl is-active resolvconf.service)\n"

    else
        echo -e "\n error: can not install package $PACKAGE"
        exit 1;
    fi
}

set-dns-ip () {
    # read string input
    read -p "Enter dns ip and Separate IPs with commas (dns-ip1,dns-ip2,...): " ips

    # Set comma as delimiter
    IFS=','

    # Read the split words intp on array based on comma delimiter.
    read -a strarr <<< "$ips"

    if [[ ! -z $DNF ]]; then
        echo "TODO"

    elif [[ ! -z $APT ]]; then
        for (( n=0; n < ${#strarr[*]}; n++ ))
        do
            echo -e "nameserver ${strarr[n]}" >> /etc/resolvconf/resolv.conf.d/head
        done
        resolvconf --enable-updates
        resolvconf -u
    else
        echo -e "\n error: can not install package $PACKAGE"
        exit 1;        
    fi
}

getInput () {
    echo -e "1. install and run resolvconf service.\n2. get dns ips"
    read -p "1/2: " cin

    if [ $cin -eq '1' ]; then
        install-run-resolvconf-service
    elif [ $cin -eq '2' ]; then
        set-dns-ip
    else
        echo -e "\n\tinput invalid."
    fi
}

getInput