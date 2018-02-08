#!/bin/bash

# support_of_mtu_setting
# IN :N/A
# OUT:N/A

function ge_set_mtu_value()
{
    Test_Case_Title="ge_set_mtu_value"
    echo ${Test_Case_Title}
    valuelist="68 1500 1501 9706"
    for value in $valuelist
    do
        echo $value
        ifconfig ${local_tp1} mtu $value
        NewMtuValue=$(ifconfig eth1 | grep "MTU" | awk '{print $(NF-1)}' | awk -F':' '{print $NF}')
        if [ $value -ne $NewMtuValue ];then
            MESSAGE="FAIL\t MTU value set fail "
	    echo ${MESSAGE}
        fi
    done
    MESSAGE="PASS"
    echo ${MESSAGE}
}

function ge_set_fail_mtu_value()
{
    Test_Case_Title="ge_set_fail_mtu_value"
    echo ${Test_Case_Title}
    valuelist="67 9707"
    for value in $valuelist
    do
        echo $value
        ifconfig ${local_tp1} mtu $value
        if [ $? -ne 0 ];then
            MESSAGE="FAIL\t MTU Incoming error parameters set fail "
	    echo ${MESSAGE}
        fi
    done
    MESSAGE="PASS" 
    echo $MESSAGE   
}

function ge_iperf_set_mtu_value()
{
    Test_Case_Title="ge_iperf_set_mtu_value"
    echo ${Test_Case_Title}
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    #??iperf????
    determine_iperf_exists
    if [ $? -eq 1 ];then
        MESSAGE="FAIL\t Iperf tools are not installed "
	echo ${MESSAGE}
        return 1
    fi
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;iperf -s >/dev/null 2>&1 &"
    iperf -c ${remote_tp1_ip} -t 3600 -i 2 -P 3 > ${HNS_TOP_DIR}/data/log/iperf_set_mtu_value.txt &
    valuelist="68 1500 9706"
    for ((i=1;i<=100;i++));
    do
        for value in $valuelist
        do
            ifconfig ${local_tp1} mtu $value;sleep 5
            NewMtuValue=$(ifconfig eth1 | grep "MTU" | awk '{print $(NF-1)}' | awk -F':' '{print $NF}')
            bandwidth=$(cat ${HNS_TOP_DIR}/data/log/iperf_set_mtu_value.txt | tail -1 | awk '{print $(NF-1)}')
            if [ $value -ne $NewMtuValue ] || [ $bandwidth -le 0 ];then
                killall iperf
                ssh root@${BACK_IP} "killall iperf"
                MESSAGE="FAIL\t MTU value set fail "
		echo ${MESSAGE}
            fi
        done
    done
    killall iperf
    ssh root@${BACK_IP} "killall iperf"
    MESSAGE="PASS"
    echo ${MESSAGE}
}


###### XGE support_of_mtu_setting ######
function xge_set_mtu_value()
{
    Test_Case_Title="xge_set_mtu_value"
    echo ${Test_Case_Title}
    valuelist="68 1500 1501 9706"
    for value in $valuelist
    do
        echo $value
        ifconfig ${local_fibre1} mtu $value
        NewMtuValue=$(ifconfig eth1 | grep "MTU" | awk '{print $(NF-1)}' | awk -F':' '{print $NF}')
        if [ $value -ne $NewMtuValue ];then
            MESSAGE="FAIL\t MTU value set fail "
	    echo ${MESSAGE}
        fi
    done
    MESSAGE="PASS"
    echo ${MESSAGE}
}

function xge_set_fail_mtu_value()
{
    Test_Case_Title="xge_set_fail_mtu_value"
    valuelist="67 9707"
    for value in $valuelist
    do
        #echo $value
        ifconfig ${local_fibre1} mtu $value
        if [ $? -ne 0 ];then
            MESSAGE="FAIL\t MTU Incoming error parameters set fail "
        fi
    done
    MESSAGE="PASS"    
}

function xge_iperf_set_mtu_value()
{
    Test_Case_Title="xge_iperf_set_mtu_value"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    
    #??iperf????
    determine_iperf_exists
    if [ $? -eq 1 ];then
        MESSAGE="FAIL\t Iperf tools are not installed "
        return 1
    fi
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5;iperf -s >/dev/null 2>&1 &"
    iperf -c ${remote_fibre1_ip} -t 3600 -i 2 -P 3 > ${HNS_TOP_DIR}/data/log/iperf_set_mtu_value.txt &
    valuelist="68 1500 9706"
    for ((i=1;i<=100;i++));
    do
        for value in $valuelist
        do
            echo $i
            echo $value
            ifconfig ${local_fibre1} mtu $value;sleep 5
            NewMtuValue=$(ifconfig eth1 | grep "MTU" | awk '{print $(NF-1)}' | awk -F':' '{print $NF}')
            bandwidth=$(cat ${HNS_TOP_DIR}/data/log/iperf_set_mtu_value.txt | tail -1 | awk '{print $(NF-1)}')
            if [ $value -ne $NewMtuValue ] || [ $bandwidth -le 0 ];then
                killall iperf
                ssh root@${BACK_IP} "killall iperf"
                MESSAGE="FAIL\t MTU value set fail "
            fi
        done
    done
    killall iperf
    ssh root@${BACK_IP} "killall iperf"
    MESSAGE="PASS"
}

function main()
{
    test_case_switch
}
main
