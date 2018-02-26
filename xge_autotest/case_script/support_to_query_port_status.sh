#!/bin/bash

# Support to Query Port Status
# IN :N/A
# OUT:N/A

function ge_query_link_state()
{
    Test_Case_Title="ge_query_link_state"
    echo "Begin to run "${Test_Case_Title}
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;"
    
    ifconfig ${local_tp1} down
    for ((i=1;i<=10;i++));
    do
        enableok=0
        disableok=0
        ssh root@${BACK_IP} "ifconfig ${remote_tp1} down"
        LinkState=$(ethtool ${local_tp1} | grep "Link detected:" | awk -F":" '{print $NF}' | tr -d ' ')
        if [ "$LinkState" = "no" ];then
            enableok=1
        fi
        
        ssh root@${BACK_IP} "ifconfig ${remote_tp1} up"
        LinkState=$(ethtool ${local_tp1} | grep "Link detected:" | awk -F":" '{print $NF}' | tr -d ' ')
        if [ "$LinkState" = "no" ];then
            disableok=1
        fi
        if [ $enableok -eq 1 -a $disableok -eq 1 ];then
            MESSAGE="PASS"
        else
            MESSAGE="FAIL\t Ping packet failure"
            break
        fi
    done
    
    ifconfig ${local_tp1} up
    for ((i=1;i<=10;i++));
    do
	echo $i
        enableok=0
        disableok=0
        ssh root@${BACK_IP} "ifconfig ${remote_tp1} down"
	if [ $i -gt 1  ];then
		sleep 5
	fi
        LinkState=$(ethtool ${local_tp1} | grep "Link detected:" | awk -F":" '{print $NF}' | tr -d ' ')
        if [ "$LinkState" = "no" ];then
            enableok=1
        fi
        
        ssh root@${BACK_IP} "ifconfig ${remote_tp1} up"
	sleep 5
        LinkState=$(ethtool ${local_tp1} | grep "Link detected:" | awk -F":" '{print $NF}' | tr -d ' ')
        if [ "$LinkState" = "yes" ];then
            disableok=1
        fi
        if [ $enableok -eq 1 -a $disableok -eq 1 ];then
            MESSAGE="PASS"
        else
            MESSAGE="FAIL\t Ping packet failure"
            break
        fi
	echo $enableok
	echo $disableok
    done
    echo ${MESSAGE}
}

function ge_link_state_fault_tolerant()
{
    Test_Case_Title="ge_link_statefault_tolerant"
    ethtool eth10 > ${HNS_TOP_DIR}/data/log/ge_link_statefault_tolerant.txt 2>&1
    cat ${HNS_TOP_DIR}/data/log/ge_link_statefault_tolerant.txt | grep "get link status: No such device"
    if [ $? = 0 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t No print error information"
    fi    
}

function xge_query_link_state()
{
    Test_Case_Title="xge_query_link_state"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5;"
    
    ifconfig ${local_fibre1} down
    for ((i=1;i<=10;i++));
    do
        enableok=0
        disableok=0
        ssh root@${BACK_IP} "ifconfig ${remote_fibre1} down"
        LinkState=$(ethtool ${local_fibre1} | grep "Link detected:" | awk -F":" '{print $NF}' tr -d ' ')
        if [ "$LinkState" = "no" ];then
            enableok=1
        fi
        
        ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up"
        LinkState=$(ethtool ${local_fibre1} | grep "Link detected:" | awk -F":" '{print $NF}' tr -d ' ')
        if [ "$LinkState" = "no" ];then
            disableok=1
        fi
        if [ $enableok -eq 1 -a $disableok -eq 1 ];then
            MESSAGE="PASS"
        else
            MESSAGE="FAIL\t Ping packet failure"
            break
        fi
    done
    
    ifconfig ${local_fibre1} up
    for ((i=1;i<=10;i++));
    do
        enableok=0
        disableok=0
        ssh root@${BACK_IP} "ifconfig ${remote_fibre1} down"
        LinkState=$(ethtool ${local_fibre1} | grep "Link detected:" | awk -F":" '{print $NF}' tr -d ' ')
        if [ "$LinkState" = "no" ];then
            enableok=1
        fi
        
        ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up"
        LinkState=$(ethtool ${local_fibre1} | grep "Link detected:" | awk -F":" '{print $NF}' tr -d ' ')
        if [ "$LinkState" = "yes" ];then
            disableok=1
        fi
        if [ $enableok -eq 1 -a $disableok -eq 1 ];then
            MESSAGE="PASS"
        else
            MESSAGE="FAIL\t Ping packet failure"
            break
        fi
    done
}

function main()
{
    test_case_switch
}
main
