#!/bin/bash

# Support to change MAC address
# IN :N/A
# OUT:N/A

function ge_mac_address_random_generation()
{
    Test_Case_Title="ge_mac_address_random_generation"
    echo "Begin to run "${Test_Case_Title}
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;"
    
    MacAddress1=$(ifconfig ${local_tp1} | grep "HWaddr" | awk '{print $NF}' | tr -d ':')
    
    ifconfig ${local_tp1} down;sleep 5
    MacAddress2=$(ifconfig ${local_tp1} | grep "HWaddr" | awk '{print $NF}' | tr -d ':')
    ifconfig ${local_tp1} up
    if [ "$MacAddress1" = "$MacAddress2" ];then
        MESSAGE="PASS"
	echo ${MESSAGE}
    else
        MESSAGE="FAIL\t MAC addresses cannot be generated randomly "
	echo ${MESSAGE}
    fi    
}

function ge_mac_address_fault_tolerant()
{
    Test_Case_Title="ge_mac_address_fault_tolerant"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;"
    OrgMacAddress1=$(ifconfig ${local_tp1} | grep "HWaddr" | awk '{print $NF}')
    echo ${OrgMacAddress1}
    gemacvalue="1 3 5 7 9"
    for i in $gemacvalue
    do
        NewMacAddress="c$i:a8:01:83:00:04"
        ifconfig ${local_tp1} hw ether $NewMacAddress | grep "SIOCSIFHWADDR: Cannot assign requested address"
        if [ $? -eq 1 ];then
            MESSAGE="FAIL\t The wrong MAC address has been configured  "
        fi
    done
    
    for x in "00:00:00:00:00:00" "ff:ff:ff:ff:ff:ff" "c1:a8:01:83:00:0418"
    do
        ifconfig ${local_tp1} hw ether $x | grep "SIOCSIFHWADDR: Cannot assign requested address"
        if [ $? -eq 1 ];then
            MESSAGE="FAIL\t The wrong MAC address has been configured  "
        fi
    done
    MESSAGE="PASS"

    ifconfig ${local_tp1} hw ether ${OrgMacAddress1} | grep "SIOCSIFHWADDR: Cannot assign requested address"

    OrgMacAddress1=$(ifconfig ${local_tp1} | grep "HWaddr" | awk '{print $NF}')
    echo "Recover mac as "${OrgMacAddress1}
    
}

function ge_set_standard_mac_address()
{
    Test_Case_Title="ge_set_standard_mac_address"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5"
    
    oldMacAddress=$(ifconfig ${local_tp1} | grep "HWaddr" | awk '{print $NF}')
    if [ ${oldMacAddress:15:2} = "00" ];then
        newMacAddress=$(echo $oldMacAddress |sed s/"${oldMacAddress:15:2}"/"22"/g)
    else
        newMacAddress=$(echo $oldMacAddress |sed s/"${oldMacAddress:15:2}"/"00"/g)
    fi
    #newMacAddress=$(echo $oldMacAddress |sed s/"${oldMacAddress:15:2}"/"00"/g)
    ifconfig ${local_tp1} hw ether ${newMacAddress}
    newMacAddress1=$(ssh root@${BACK_IP} "ping ${local_tp1_ip} -c 10;sleep 5;arp | grep ${remote_tp1_ip} | awk '{print $4}'")
    if [ "$newMacAddress" != "$newMacAddress1" ];then
        ifconfig ${local_tp1} hw ether ${oldMacAddress}
        MESSAGE="FAIL\t The wrong MAC address set fail "
    fi
    MESSAGE="PASS"
}

function ge_set_linear_mac_address()
{
    Test_Case_Title="ge_set_linear_mac_address"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5"
    
    oldMacAddress=$(ifconfig ${local_tp1} | grep "HWaddr" | awk '{print $NF}')
    for linearMacAddress in "22:22:22:22:22:22" "aa:aa:aa:aa:aa:aa"
    do
        ifconfig ${local_tp1} hw ether ${linearMacAddress}
        linearMacAddress1=$(ssh root@${BACK_IP} "ping ${local_tp1_ip} -c 10;sleep 5;arp | grep ${remote_tp1_ip} | awk '{print $4}'")
        if [ "$linearMacAddress" != "$linearMacAddress1" ];then
            ifconfig ${local_tp1} hw ether ${oldMacAddress}
            MESSAGE="FAIL\t set linear mac address fail "
        fi
    done
    MESSAGE="PASS"
}



###### XGE Support to change MAC address ######
function xge_mac_address_random_generation()
{
    Test_Case_Title="xge_mac_address_random_generation"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5;"
    
    MacAddress1=$(ifconfig ${local_tp1} | grep "HWaddr" | awk '{print $NF}' | tr -d ':')
    
    ifconfig ${local_fibre1} down;sleep 5
    MacAddress2=$(ifconfig ${local_tp1} | grep "HWaddr" | awk '{print $NF}' | tr -d ':')
    ifconfig ${local_fibre1} up
    if [ "$MacAddress1" = "$MacAddress2" ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t MAC addresses cannot be generated randomly "
    fi    
}

function xge_mac_address_fault_tolerant()
{
    Test_Case_Title="xge_mac_address_fault_tolerant"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5;"
    xgemacvalue="1 3 5 7 9"
    for i in $xgemacvalue
    do
        NewMacAddress="c$i:a8:01:83:00:04"
        ifconfig ${local_fibre1} hw ether $NewMacAddress | grep "SIOCSIFHWADDR: Cannot assign requested address"
        if [ $? -eq 1 ];then
            MESSAGE="FAIL\t The wrong MAC address has been configured  "
        fi
    done
    
    for x in "00:00:00:00:00:00" "ff:ff:ff:ff:ff:ff" "c1:a8:01:83:00:0418"
    do
        ifconfig ${local_fibre1} hw ether $x | grep "SIOCSIFHWADDR: Cannot assign requested address"
        if [ $? -eq 1 ];then
            MESSAGE="FAIL\t The wrong MAC address has been configured  "
        fi
    done
    MESSAGE="PASS"
}

function xge_set_standard_mac_address()
{
    Test_Case_Title="xge_set_standard_mac_address"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5"
    
    oldMacAddress=$(ifconfig ${local_fibre1} | grep "HWaddr" | awk '{print $NF}')
    if [ ${oldMacAddress:15:2} = "00" ];then
        newMacAddress=$(echo $oldMacAddress |sed s/"${oldMacAddress:15:2}"/"22"/g)
    else
        newMacAddress=$(echo $oldMacAddress |sed s/"${oldMacAddress:15:2}"/"00"/g)
    fi
    #newMacAddress=$(echo $oldMacAddress |sed s/"${oldMacAddress:15:2}"/"00"/g)
    ifconfig ${local_fibre1} hw ether ${newMacAddress}
    newMacAddress1=$(ssh root@${BACK_IP} "ping ${local_fibre1_ip} -c 10;sleep 5;arp | grep ${remote_fibre1_ip} | awk '{print $4}'")
    if [ "$newMacAddress" != "$newMacAddress1" ];then
        ifconfig ${local_fibre1} hw ether ${oldMacAddress}
        MESSAGE="FAIL\t The wrong MAC address set fail "
    fi
    MESSAGE="PASS"
}

function xge_set_linear_mac_address()
{
    Test_Case_Title="xge_set_linear_mac_address"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5"
    
    oldMacAddress=$(ifconfig ${local_fibre1} | grep "HWaddr" | awk '{print $NF}')
    for linearMacAddress in "22:22:22:22:22:22" "aa:aa:aa:aa:aa:aa"
    do
        ifconfig ${local_fibre1} hw ether ${linearMacAddress}
        linearMacAddress1=$(ssh root@${BACK_IP} "ping ${local_fibre1_ip} -c 10;sleep 5;arp | grep ${remote_fibre1_ip} | awk '{print $4}'")
        if [ "$linearMacAddress" != "$linearMacAddress1" ];then
            ifconfig ${local_fibre1} hw ether ${oldMacAddress}
            MESSAGE="FAIL\t set linear mac address fail "
        fi
    done
    MESSAGE="PASS"
}

function main()
{
    test_case_switch
}
main
