#!/bin/bash

# Support to IPv6
# IN :N/A
# OUT:N/A

function ge_ipv6_ping_pack()
{
    Test_Case_Title="ge_ipv6_ping_pack"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;"
    RemoteIpv6Address=$(ssh root@${BACK_IP} "ifconfig "${remote_tp1}" | grep 'inet6' | awk '{print \$(NF-1)}' | awk -F'/' '{print \$1}'") 
    ping6 ${RemoteIpv6Address}%${local_tp1} -c 5 > ${HNS_TOP_DIR}/data/log/ipv6_ping_pack.txt &
    sleep 10
    echo  `cat ${HNS_TOP_DIR}/data/log/ipv6_ping_pack.txt`   
    cat ${HNS_TOP_DIR}/data/log/ipv6_ping_pack.txt | grep "received, 0% packet loss"
    if [ x"$?" = x"0" ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t ipv6 addresses ping packe fial "
    fi
}

function ge_set_ipv6_address()
{
    Test_Case_Title="ge_set_ipv6_address"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;"
    ifconfig ${local_tp1} inet6 add ${local_tp1_ipv6_ip}
    ssh root@${BACK_IP} "ping6 ${local_tp1_ipv6_ip}%${remote_tp1} -c 5" > ${HNS_TOP_DIR}/data/log/set_ipv6_address.txt &

    sleep 10
    cat ${HNS_TOP_DIR}/data/log/ipv6_ping_pack.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
        ifconfig ${local_tp1} inet6 del ${local_tp1_ipv6_ip}
        MESSAGE="PASS"
    else
        ifconfig ${local_tp1} inet6 del ${local_tp1_ipv6_ip}
        MESSAGE="FAIL\t ipv6 addresses ping packe fial "
    fi
}

function ipv6_set_fault_tolerant()
{
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;"
    ifconfig ${local_tp1} inet6 add ${local_tp1_ipv6_ip}
}


###### XGE ipv6 ping pack ######
function xge_ipv6_ping_pack()
{
    Test_Case_Title="xge_ipv6_ping_pack"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5;"
    RemoteIpv6Address=$(ssh root@${BACK_IP} "ifconfig "${remote_fibre1}" | grep 'inet6' | awk '{print \$(NF-1)}' | awk -F'/' '{print \$1}'") 
    ping6 ${RemoteIpv6Address}%${local_fibre1} -c 5 > ${HNS_TOP_DIR}/data/log/ipv6_ping_pack.txt &
    sleep 10
    cat ${HNS_TOP_DIR}/data/log/ipv6_ping_pack.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t ipv6 addresses ping packe fial "
    fi
}

function xge_set_ipv6_address()
{
    Test_Case_Title="xge_set_ipv6_address"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5;"
    ifconfig ${local_fibre1} inet6 add ${local_fibre1_ipv6_ip}
    ssh root@${BACK_IP} "ping6 ${local_fibre1_ipv6_ip}%${remote_fibre1} -c 5" > ${HNS_TOP_DIR}/data/log/set_ipv6_address.txt &
    cat ${HNS_TOP_DIR}/data/log/ipv6_ping_pack.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
        ifconfig ${local_fibre1} inet6 del ${local_fibre1_ipv6_ip}
        MESSAGE="PASS"
    else
        ifconfig ${local_fibre1} inet6 del ${local_fibre1_ipv6_ip}
        MESSAGE="FAIL\t ipv6 addresses ping packe fial "
    fi
}

function main()
{
    test_case_switch
}
main
#ge_ipv6_ping_pack

