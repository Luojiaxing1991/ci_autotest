#!/bin/bash

# support support of MDIO
# IN :N/A
# OUT:N/A

###### GE support of MDIO ######
function ge_read_phy_register()
{
    Test_Case_Title="ge_read_phy_register"
    echo "Begin to run "${Test_Case_Title}
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    mii-tool ${local_tp1} -v > ${HNS_TOP_DIR}/data/log/read_phy_register.txt
    if [ $? -eq 0 ];then
        MESSAGE="PASS"
	echo ${MESSAGE}
    else
        MESSAGE="FAIL\t ge read phy register fail"
	echo ${MESSAGE}
    fi
}

function ge_iperf_read_phy_register()
{
    Test_Case_Title="ge_iperf_read_phy_register"
    echo "Begin to run "${Test_Case_Title}
    enableok=0
    disableok=0
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    
    #??iperf????
    determine_iperf_exists
    if [ $? -eq 1 ];then
        MESSAGE="FAIL\t Iperf tools are not installed "
	echo ${MESSAGE}
        return 1
    fi
    
    ssh root@${BACK_IP} 'ifconfig '${remote_tp1}' up; ifconfig '${remote_tp1}' '${remote_tp1_ip}'; sleep 5;iperf -s >/dev/null 2>&1 &'
    iperf -c ${remote_tp1_ip} -t 3600 -i 1 -P 3 > ${HNS_TOP_DIR}/data/log/ge_iperf_read_phy_register.txt &
    mii-tool ${local_tp1} -r
    sleep 1
    bandwidth1=$(cat ${HNS_TOP_DIR}/data/log/ge_iperf_read_phy_register.txt | tail -1 | awk '{print $(NF-1)}')
    echo $bandwidth1
    if [ x"${bandwidth1}" = x"0" ];then
        enableok=1
    fi
    echo "Check enableok "${enableok}
    sleep 10
    bandwidth2=$(cat ${HNS_TOP_DIR}/data/log/ge_iperf_read_phy_register.txt | tail -1 | awk '{print $(NF-1)}')
    echo $bandwidth2
    if [ x"${bandwidth2}" = x"0" ];then
        disableok=1
    fi
    echo "Check disableok "${disableok}

    if [ $enableok -eq 0 ] || [ $disableok -eq 0 ];then
        MESSAGE="FAIL\t auto negotiation fail"
	echo ${MESSAGE}
    else
        MESSAGE="PASS"
	echo ${MESSAGE}
    fi
}

function xge_read_phy_register()
{
    Test_Case_Title="xge_read_phy_register"
    echo ${Test_Case_Title}
    ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}
    mii-tool ${remote_fibre1} -v | grep "failed: Invalid argument" > ${HNS_TOP_DIR}/data/log/xge_read_phy_register.txt
    if [ $? -eq 0 ];then
        MESSAGE="PASS"
	echo ${MESSAGE}
    else
        MESSAGE="FAIL\t xge read phy register fail"
	echo ${MESSAGE}
    fi
}

function main()
{
    test_case_switch
}
main
