#!/bin/bash

# Support to Get Driver Informations
# IN :N/A
# OUT:N/A


function ge_query_driven_version_information()
{
    Test_Case_Title="ge_query_driven_version_information"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;"
    
    enableok=0
    disableok=0 
    driverinfo=$(ethtool -i ${local_tp1} | grep "driver:" | awk -F":" '{print $NF}' | tr -d ' ')
    if [ "$driverinfo" = "hns" ];then
        enableok=1
    fi

    versioninfo=$(ethtool -i ${local_tp1} | grep "^version:" | awk -F":" '{print $NF}' | tr -d ' ')
    if [ "$versioninfo" = "2.0" ];then
        disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t driverinfo/versioninfo info query fail"
    fi
}

function ge_query_driven_version_fault_tolerant()
{
    Test_Case_Title="ge_query_driven_version_fault_tolerant"
    ethtool -i eth10 > ${HNS_TOP_DIR}/data/log/ge_query_driven_version_fault_tolerant.txt 2>&1
    cat ${HNS_TOP_DIR}/data/log/ge_query_driven_version_fault_tolerant.txt | grep "Cannot get driver information: No such device"
    if [ $? = 0 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t No print error information"
    fi    
}

function xge_query_driven_version_information()
{
    Test_Case_Title="xge_query_driven_version_information"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5;"
 
    enableok=0
    disableok=0 
    driverinfo=$(ethtool -i ${local_fibre1} | grep "driver:" | awk -F":" '{print $NF}' | tr -d ' ')
    if [ "$driverinfo" = "hns" ];then
        enableok=1
    fi

    versioninfo=$(ethtool -i ${local_fibre1} | grep "^version:" | awk -F":" '{print $NF}' | tr -d ' ')
    if [ "$versioninfo" = "2.0" ];then
        disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t driverinfo/versioninfo info query fail"
    fi
}

function main()
{
    test_case_switch
}
main
