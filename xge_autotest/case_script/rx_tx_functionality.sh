#!/bin/bash

# tx/rx Functionality
# IN :N/A
# OUT:N/A
function ge_two_ends_receiving_and_sending ()
{
    Test_Case_Title="ge_two_ends_receiving_and_sending"
    echo "Begin to run "${Test_Case_Title}
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@$BACK_IP 'ifconfig '${remote_tp1}' up; ifconfig '${remote_tp1}' '${remote_tp1_ip}'; sleep 5;'
    ping ${remote_tp1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/ge_two_ends_receiving_and_sending.txt &
    sleep 10
    cat ${HNS_TOP_DIR}/data/log/ge_two_ends_receiving_and_sending.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
       enableok=1
    fi

    ssh root@$BACK_IP 'ping '${local_tp1_ip}' -c 5' > ${HNS_TOP_DIR}/data/log/ge_two_ends_receiving_and_sending.txt &
    sleep 10
    cat ${HNS_TOP_DIR}/data/log/ge_two_ends_receiving_and_sending.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
       disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        MESSAGE="PASS"
	echo ${MESSAGE}
    else
        MESSAGE="FAIL\t Ping packet failure"
	echo ${MESSAGE}
    fi
}

function xge_two_ends_receiving_and_sending ()
{
    Test_Case_Title="xge_two_ends_receiving_and_sending"
    echo "Begin to run "${Test_Case_Title}
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@$BACK_IP 'ifconfig '${remote_fibre1}' up; ifconfig '${remote_fibre1}' '${remote_fibre1_ip}'; sleep 5;'
    ping ${remote_fibre1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/xge_two_ends_receiving_and_sending.txt &
    sleep 10
    cat ${HNS_TOP_DIR}/data/log/xge_two_ends_receiving_and_sending.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
       enableok=1
    fi

    ssh root@$BACK_IP 'ping '${local_fibre1_ip}' -c 5' > ${HNS_TOP_DIR}/data/log/xge_two_ends_receiving_and_sending.txt &
    sleep 10
    cat ${HNS_TOP_DIR}/data/log/xge_two_ends_receiving_and_sending.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 1 ];then
       disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        MESSAGE="PASS"
	echo ${MESSAGE}
    else
        MESSAGE="FAIL\t Ping packet failure"
	echo ${MESSAGE}
    fi
}

function main()
{
    test_case_switch
}
main

