#!/bin/bash
# TX/RX Functionality
# IN :N/A
# OUT:N/A
function ping()
{
    echo $1
    if [ $1 == "eth1" ];then
	IP="192.168.10.20"
	BACK_IP="192.168.10.10"
    elif [ $1 == "eth2" ];then
        IP="192.168.20.20"
        BACK_IP="192.168.20.10"
    else
	IP="192.168.30.20"
	BACK_IP="192.168.30.10"
    ifconfig $1 $IP
    ssh root@$BACK_IP `ifconfig $1 $BACK_IP`
    fi
    sleep 5

    Link=`ethtool $1 | grep "Link detected" | awk '{print $NF}'`
    if [ Link == "on" ];then
	pass
    else
	echo "network no link"
	return 1

    ping $BACK_IP -c 5 > ping_$1.log &
    sleep 10
    fi

    cat ping_$1.log | grep "0% packet loss"
    if [ $? -eq 0 ];then
        writePass
    else
	writeFail
    fi
}

function main()
{
    JIRA_ID="PV-435 PV-952"
    Test_Item="TX/RX Functionality"
    Designed_Requirement_ID="R.HNS.F003.A"
    ping
}

