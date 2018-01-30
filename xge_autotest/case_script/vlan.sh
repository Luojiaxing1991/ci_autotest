#!/bin/bash

# support to vlan
# IN :N/A
# OUT:N/A
function VlanMultiport()
{
    Test_Case_Title="vlan ping funciton"
    Test_Case_ID="ST_GE_VLAN_005"

    ifconfig eth1 up;ifconfig eth2 up
    ip link add link eth1 name eth1.401 type vlan id 401
    ip link add link eth2 name eth2.400 type vlan id 400
    ifconfig eth1.401 192.168.21.10;ifconfig eht2.400 192.168.22.10
    sleep 5

    ssh root@$BACK_IP << remotessh 
    ifconfig eth1 up;ifconfig eth2 up
    ip link add link eth1 name eth1.401 type vlan id 401
    ip link add link eth2 name eth2.400 type vlan id 400
    ifconfig eth1.401 192.168.21.20;ifconfig eht2.400 192.168.22.20
    sleep 10    
    exit
remotessh

    for i in "192.168.21.20 192.168.22.20"
    do
        ping $i -c 2 | tee -a pingvlan.log | grep "0% packet loss"
        if [ $? -eq 0 ];then
            writePass
        else
            writeFail
        fi
    done
}

function VlanFaultTolerant()
{
    Test_Case_Title="vlan fault-tolerant"
    Test_Case_ID="ST_GE_VLAN_015"
    ip link add link eth10 name eth10.401 type vlan id 401 | tee -a pingvlan.log
    sleep 5
    if [ $? -eq 0 ];then
        writePass
    else
        writeFail
    fi

}

function SetVlan()
{
    Test_Case_Title="vlan ping funciton"
    Test_Case_ID="ST_GE_VLAN_010"
    for i in $NetworkErgodic
    do
        ifconfig $i up
        ip link add link $i name $i.401 type vlan id 401
        ifconfig $i.401 `eval echo '$'VLAN_local_"$i"_ip`
        sleep 5
        ssh root@$BACK_IP `ifconfig $i up;ip link add link $i name $i.401 type vlan id 401;ifconfig $i.401 `eval echo '$'VLAN_remore_"$i"_ip`;sleep 10`
        ping `eval echo '$'VLAN_remore_"$i"_ip` -c 2 | tee -a pingvlan.log | grep "0% packet loss"
        if [ $? -eq 0 ];then
            writePass
        else
            writeFail
        fi
    done
}

function usage()
{
    echo "$0 all | SetVlan | VlanFaultTolerant | VlanMultiport"
}

function main()
{
    JIRA_ID="PV-1490"
    Test_Item="VLAN Tagged Traffic support"
    Designed_Requirement_ID="R.HNS.F005A"
    :> setvlan.log
    ConfigVlan=`zcat /proc/config.gz | grep -w "CONFIG_VLAN_8021Q" | awk -F"=" '{print $2}'`
    if [ $ConfigVlan -eq "m" ];then
        echo "***Please build VLAN into kernel***"
    fi
}

main

if [ $# = 0 ];then
    test_type="all"
else
    rest_type="$1"
fi

case $test_type in
"all")
    SetVlan
    VlanFaultTolerant
    VlanMultiport
;;
"SetVlan")
    SetVlan
;;
"VlanFaultTolerant")
    VlanFaultTolerant
;;
"VlanMultiport")
    VlanMultiport
*)
    usage
    exit
;;
esac
