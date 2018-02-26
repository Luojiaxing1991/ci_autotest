#!/bin/bash

# support to vlan
# IN :N/A
# OUT:N/A

###### GE VLAN Tagged Traffic Support ######
function ge_vlan_multi_port()
{
    Test_Case_Title="ge_vlan_multi_port"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ip link add link ${local_tp1} name ${local_tp1}.401 type vlan id 401
    ip link add link ${local_tp1} name ${local_tp1}.400 type vlan id 400
    ifconfig ${local_tp1}.401 192.168.11.10;ifconfig ${local_tp1}.400 192.168.12.10
    sleep 5

    ssh root@$BACK_IP "
    ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip};\
    ip link add link ${remote_tp1} name ${remote_tp1}.401 type vlan id 401;\
    ip link add link ${remote_tp1} name ${remote_tp1}.400 type vlan id 400;\
    ifconfig ${remote_tp1}.401 192.168.11.20;ifconfig ${remote_tp1}.400 192.168.12.20;\
    sleep 10"

    for i in "192.168.11.20 192.168.12.20"
    do
        ping $i -c 5 | tee -a ${HNS_TOP_DIR}/data/log/ge_vlan_multi_port.log | grep "received, 0% packet loss"
        if [ $? -eq 0 ];then
            MESSAGE="PASS"
        else
            MESSAGE="FAIL\t vlan Ping packet failure"
        fi
    done
}

function vlan_fault_tolerant()
{
    Test_Case_Title="vlan_fault_tolerant"
    ip link add link eth10 name eth10.401 type vlan id 401 | tee -a ${HNS_TOP_DIR}/data/log/vlan_fault_tolerant.log
    sleep 5
    if [ $? -eq 1 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t vlan fault tolerant failure"
    fi

}

function ge_set_vlan()
{
    Test_Case_Title="ge_set_vlan"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ip link add link ${local_tp1} name ${local_tp1}.401 type vlan id 401
    ifconfig ${local_tp1}.401 192.168.11.10
    sleep 5
    ssh root@$BACK_IP "ifconfig ${remote_tp1} up;\
    ip link add link $i name ${remote_tp1}.401 type vlan id 401;\
    ifconfig ${remote_tp1}.401 192.168.11.20;\
    sleep 10"
    ping 192.168.11.20 -c 5 | tee -a ${HNS_TOP_DIR}/data/log/ge_set_vlan.log | grep "received, 0% packet loss"
    if [ $? -eq 0 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t vlan Ping packet failure"
    fi
}

function ge_vlan_up_down
{
    Test_Case_Title="ge_vlan_up_down"
     ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ip link add link ${local_tp1} name ${local_tp1}.401 type vlan id 401
    ifconfig ${local_tp1}.401 192.168.11.10
    sleep 5
    
    ifconfig ${local_tp1} down
    ifconfig ${local_tp1}.401 | grep "UP"
    if [ $? -eq 1 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t vlan up/down failure"
    fi
}


###### XGE VLAN Tagged Traffic Support ######
function xge_vlan_multi_port()
{
    Test_Case_Title="xge_vlan_multi_port"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ip link add link ${local_fibre1} name ${local_fibre1}.401 type vlan id 401
    ip link add link ${local_fibre1} name ${local_fibre1}.400 type vlan id 400
    ifconfig ${local_fibre1}.401 192.168.21.10;ifconfig ${local_fibre1}.400 192.168.22.10
    sleep 5

    ssh root@$BACK_IP "
    ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip};\
    ip link add link ${remote_fibre1} name ${remote_fibre1}.401 type vlan id 401;\
    ip link add link ${remote_fibre1} name ${remote_fibre1}.400 type vlan id 400;\
    ifconfig ${remote_fibre1}.401 192.168.21.20;ifconfig ${remote_fibre1}.400 192.168.22.20;\
    sleep 10"

    for i in "192.168.21.20 192.168.22.20"
    do
        ping $i -c 5 | tee -a ${HNS_TOP_DIR}/data/log/xge_vlan_multi_port.log | grep "received, 0% packet loss"
        if [ $? -eq 0 ];then
            MESSAGE="PASS"
        else
            MESSAGE="FAIL\t vlan Ping packet failure"
        fi
    done
}

function xge_set_vlan()
{
    Test_Case_Title="xge_set_vlan"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ip link add link ${local_fibre1} name ${local_fibre1}.401 type vlan id 401
    ifconfig ${local_fibre1}.401 192.168.21.10
    sleep 5
    ssh root@$BACK_IP "ifconfig ${remote_fibre1} up;\
    ip link add link $i name ${remote_fibre1}.401 type vlan id 401;\
    ifconfig ${remote_fibre1}.401 192.168.21.20;\
    sleep 10"
    ping 192.168.21.20 -c 5 | tee -a ${HNS_TOP_DIR}/data/log/xge_set_vlan.log | grep "received, 0% packet loss"
    if [ $? -eq 0 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t vlan Ping packet failure"
    fi
}

function xge_vlan_up_down
{
    Test_Case_Title="xge_vlan_up_down"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ip link add link ${local_fibre1} name ${local_fibre1}.401 type vlan id 401
    ifconfig ${local_fibre1}.401 192.168.21.10
    sleep 5
    
    ifconfig ${local_fibre1} down
    ifconfig ${local_fibre1}.401 | grep "UP"
    if [ $? -eq 1 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t vlan up/down failure"
    fi
}

function main()
{
    ConfigVlan=`zcat /proc/config.gz | grep -w "CONFIG_VLAN_8021Q" | awk -F"=" '{print $2}'`
    if [ $ConfigVlan -eq "m" ];then
        MESSAGE="FAIL\t Please build VLAN into kernel"
    fi
    test_case_switch
}

main

