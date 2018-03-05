#!/bin/bash

# Support of Ring parameter Gettings
# IN :N/A
# OUT:N/A

function ge_query_ring_parameter_gettings()
{
    Test_Case_Title="ge_query_ring_parameter_gettings"
    echo "Begin to run "${Test_Case_Title}
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;"
    MESSAGE="PASS"

    enableok=0
    disableok=0
    for ((i=1;i<=10;i++));
    do
        ifconfig ${local_tp1} down
        RingParameter=$(ethtool -g ${local_tp1} | grep "\(RX:\|TX:\)" | awk '{print $NF}')
        for i in $RingParameter
	do
            if [ "$i" = "1024" ];then
                enableok=1
            fi
        done
        ifconfig ${local_tp1} up
        RingParameter=$(ethtool -g ${local_tp1} | grep "\(RX:\|TX:\)" | awk '{print $NF}')
        for i in $RingParameter
	do
            if [ "$i" = "1024" ];then
                disableok=1
            fi
        done
        if [ $enableok -eq 0 -a $disableok -eq 0 ];then
            MESSAGE="FAIL\t ring parameter query fail"
        fi
    done
    echo ${MESSAGE}
}

function query_ring_parameter_fault_tolerant()
{
    Test_Case_Title="query_ring_parameter_fault_tolerant"
    ethtool -i eth10 > ${HNS_TOP_DIR}/data/log/query_ring_parameter_fault_tolerant.txt 2>&1
    cat ${HNS_TOP_DIR}/data/log/query_ring_parameter_fault_tolerant.txt | grep "No such device"
    if [ $? = 0 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t No print error information"
    fi    
}

function xge_query_ring_parameter_gettings()
{
    Test_Case_Title="xge_query_ring_parameter_gettings"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5;"
    
    enableok=0
    disableok=0
    for ((i=1;i<=10;i++));
    do
        ifconfig ${local_fibre1} down
        RingParameter=$(ethtool -g ${local_fibre1} | grep "\(RX:\|TX:\)" | awk '{print $NF}')
        for i in $RingParameter
	do
            if [ "$i" = "1024" ];then
                enableok=1
            fi
        done
        ifconfig ${local_fibre1} up
        RingParameter=$(ethtool -g ${local_fibre1} | grep "\(RX:\|TX:\)" | awk '{print $NF}')
        for i in $RingParameter
	do
            if [ "$i" = "1024" ];then
                disableok=1
            fi
        done
        if [ $enableok -eq 0 -a $disableok -eq 0 ];then
            MESSAGE="FAIL\t ring parameter query fail"
        fi
    done
    MESSAGE="PASS"
}

function main()
{
    test_case_switch
}
main
