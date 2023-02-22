#!/bin/bash

install-run-resolvconf-service () {
    DNF=$(which dnf)
    APT=$(whick apt-get)

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
    echo "TODO"
}

getInput () {
    echo -e "1. install and run resolvconf service.\n2. get dns ip with this format(dns-ip1, dns-ip2, ...)"
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