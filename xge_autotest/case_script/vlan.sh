#!/bin/bash

# support to vlan
# IN :N/A
# OUT:N/A
function vlantest()
{
    Test_Case_Title="vlan ping funciton"
    Test_Case_ID="ST_GE_VLAN_000"
    :> pingvlan.txt
    zcat /proc/config.gz | grep -w "CONFIG_VLAN_8021Q"
    if [ $? -eq 1 ];then
       echo "***Please build VLAN into kernel***"
    fi
    ifconfig eth1 up
    ip link add link eth1 name eth1.401 type vlan id 401
    ifconfig eth1.401 up
    ifconfig eth1.401 192.168.101.212
    sleep 10
    #eth1401=$(ssh root@$BACK_IP 'ifconfig eth1 up; sleep 10; linkstatus=$(ethtool eth1 | grep "Link detected: yes"| cut -d: -f 2); if [ "$linkstatus" == "yes" ];then ip link add link eth1 name eth1.401 type vlan id 401;ifconfig eth1.401 up; ifconfig eth1.401 192.168.101.200;fi; ifconfig -a | grep "eth1.401" -A 6 | grep "inet addr:"| grep -Po "(?<=addr:)([^ ]*)"; ')
    ssh root@$BACK_IP 'ifconfig eth1 up; sleep 10; ip link add link eth1 name eth1.401 type vlan id 401; ifconfig eth1.401 up; ifconfig eth1.401 192.168.101.200; sleep 20;'
    sleep 10
    ping 192.168.101.200 -c 5 >pingvlan.txt
    cat pingvlan.txt | grep "0% packet loss"
    result=`echo $?`
    if [ $result -eq 0 ];then
      writePass
    else
      writeFail
    fi
    #  ip link del eth1.401
    rm -rf pingvlan.txt
}
function main()
{
    JIRA_ID="PV-1490"
    Test_Item="VLAN Tagged Traffic support"
    Designed_Requirement_ID="R.HNS.F005A"
    vlantest
}
main
