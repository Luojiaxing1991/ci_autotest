#!/bin/bash

# support auto negotiation
# IN :N/A
# OUT:N/A

###### GE auto negotiation ######
function ge_restarts_auto_negotiation()
{
    Test_Case_Title="ge_restarts_auto_negotiation"
    echo "Begin to run "${Test_Case_Title}
    echo "Begin to up the local "${local_tp1}
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    echo "Begin to ssh remote "${remote_tp1}
    ssh root@${BACK_IP} 'ifconfig '${remote_tp1}' up; ifconfig '${remote_tp1}' '${remote_tp1_ip}'; sleep 5;'
    i=1
    while(($i<=10))
    do
	echo "Begin cycle "$i
        enableok=0
        disableok=0
        ethtool -r ${local_tp1}
        sleep 5
        ping ${remote_tp1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/ge_restarts_auto_negotiation.txt &
        sleep 10    
        cat ${HNS_TOP_DIR}/data/log/ge_restarts_auto_negotiation.txt | grep "received, 0% packet loss" >/dev/null
        if [ $? -eq 0 ];then
            enableok=1
	    echo $enableok
        fi
        ifconfig ${local_tp1} down
        ethtool -r ${local_tp1}
        sleep 5
        ifconfig ${local_tp1} up
        sleep 2
        ping ${remote_tp1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/ge_restarts_auto_negotiation.txt &
        sleep 10
        cat ${HNS_TOP_DIR}/data/log/ge_restarts_auto_negotiation.txt | grep "received, 0% packet loss" >/dev/null
        if [ $? -eq 0 ];then
            disableok=1
        fi
	echo "The result of Enable net is "$enableok
	echo "The result of disable net is "$disableok

        if [ $enableok -eq 0 ] || [ $disableok -eq 0 ];then
            MESSAGE="FAIL\t auto negotiation fail"
	    echo ${MESSAGE}
            break
        fi
        i=$(($i+1))
    done
    MESSAGE="PASS"
    echo ${MESSAGE}
}

function ge_iperf_auto_negotiation()
{
    Test_Case_Title="ge_iperf_auto_negotiation"
    echo "Begin to run "${Test_Case_Title}
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} 'ifconfig '${remote_tp1}' up; ifconfig '${remote_tp1}' '${remote_tp1_ip}'; sleep 5;iperf -s >/dev/null 2>&1 &'
    iperf -c ${remote_tp1} -t 3600 -i 2 -P 3 > ${HNS_TOP_DIR}/data/log/ge_iperf_auto_negotiation.txt &
    for ((i=1;i<=10;i++));
    do
        echo "Begin ethtool "$i
        ethtool -r ${local_tp1}
        sleep 10
    done
    ping ${remote_tp1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/ge_ping_auto_negotiation.txt &
    sleep 10    
    cat ${HNS_TOP_DIR}/data/log/ge_ping_auto_negotiation.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
        enableok=1
    fi
    if [ $enableok -eq 1 ];then
        killall iperf
        ssh root@${BACK_IP} "killall iperf"
        MESSAGE="PASS"
	echo ${MESSAGE}
    else
        killall iperf
        ssh root@${BACK_IP} "killall iperf"
        MESSAGE="FAIL\t iperf auto negotiation fail"
	echo ${MESSAGE}
    fi
}


###### XGE auto negotiation ######
function xge_restarts_auto_negotiation()
{
    Test_Case_Title="xge_restarts_auto_negotiation"
    echo "Begin to run "${Test_Case_Title}
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig "${remote_tp1}" up; ifconfig "${remote_fibre1}" "${remote_fibre1_ip}"; sleep 5"
    i=1
    while(($i<=10))
    do
        enableok=0
        disableok=0
        ethtool -r ${local_fibre1}
        sleep 5
        ping ${remote_fibre1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/xge_restarts_auto_negotiation.txt &
        sleep 10    
        cat ${HNS_TOP_DIR}/data/log/xge_restarts_auto_negotiation.txt | grep "received, 0% packet loss" >/dev/null
        if [ $? -eq 0 ];then
            enableok=1
        fi
        ifconfig ${local_fibre1} down
        ethtool -r ${local_fibre1}
        sleep 5
        ifconfig ${local_fibre1} up
        sleep 2
        ping ${remote_fibre1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/xge_restarts_auto_negotiation.txt &
        sleep 10
        cat ${HNS_TOP_DIR}/data/log/xge_restarts_auto_negotiation.txt | grep "received, 0% packet loss" >/dev/null
        if [ $? -eq 0 ];then
            disableok=1
        fi
        if [ $enableok -eq 0 ] || [ $disableok -eq 0 ];then
            MESSAGE="FAIL\t auto negotiation fail"
            echo ${MESSAGE}
	    break
        fi
        i=$(($i+1))
    done
    MESSAGE="PASS"
    echo ${MESSAGE}
}

function xge_iperf_auto_negotiation()
{
    Test_Case_Title="xge_iperf_auto_negotiation"
    echo ${Test_Case_Title}
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} 'ifconfig '${remote_tp1}' up; ifconfig '${remote_fibre1}' '${remote_fibre1_ip}'; sleep 5;iperf -s >/dev/null 2>&1 &'
    iperf -c ${remote_fibre1} -t 3600 -i 2 -P 3 > ${HNS_TOP_DIR}/data/log/xge_iperf_auto_negotiation.txt &
    for ((i=1;i<=10;i++));
    do
        ethtool -r ${local_fibre1}
        sleep 10
    done
    ping ${remote_fibre1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/xge_ping_auto_negotiation.txt &
    sleep 10    
    cat ${HNS_TOP_DIR}/data/log/xge_ping_auto_negotiation.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
        enableok=1
    fi
    if [ $enableok -eq 1 ];then
        killall iperf
        ssh root@${BACK_IP} "killall iperf"
        MESSAGE="PASS"
	echo ${MESSAGE}
    else
        killall iperf
        ssh root@${BACK_IP} "killall iperf"
        MESSAGE="FAIL\t iperf auto negotiation fail"
	echo ${MESSAGE}
    fi
}

function main()
{
    test_case_switch
}
main
