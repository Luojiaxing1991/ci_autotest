#!/bin/bash

# support support of MDIO
# IN :N/A
# OUT:N/A

###### GE support of MDIO ######
function ge_read_phy_register()
{
    Test_Case_Title="ge_read_phy_register"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    mii-tool ${local_tp1} -v > ${HNS_TOP_DIR}/data/log/read_phy_register.txt
    if [ $? -eq 0 ]
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t ge read phy register fail"
    fi
}

function ge_iperf_read_phy_register()
{
    Test_Case_Title="ge_iperf_read_phy_register"
    enableok=0
    disableok=0
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    
    #??iperf????
    determine_iperf_exists
    if [ $? -eq 1 ];then
        MESSAGE="FAIL\t Iperf tools are not installed "
        return 1
    fi
    
    ssh root@${BACK_IP} 'ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;iperf -s >/dev/null 2>&1 &'
    iperf -c ${remote_tp1} -t 3600 -i 1 -P 3 > ${HNS_TOP_DIR}/data/log/ge_iperf_read_phy_register.txt &
    mii-tool ${local_tp1} -r
    sleep 1
    bandwidth1=$(cat ${HNS_TOP_DIR}/data/log/ge_iperf_read_phy_register.txt | tail -1 | awk '{print $(NF-1)}')
    if [ $bandwidth1 -eq 0 ];then
        enableok=1
    fi
    sleep 10
    bandwidth2=$(cat ${HNS_TOP_DIR}/data/log/ge_iperf_read_phy_register.txt | tail -1 | awk '{print $(NF-1)}')
    if [ $bandwidth2 -eq 0 ];then
        disableok=1
    fi
    if [ $enableok -eq 0 ] || [ $disableok -eq 0 ];then
        MESSAGE="FAIL\t auto negotiation fail"
    else
        MESSAGE="PASS"
    fi
}

function xge_read_phy_register()
{
    Test_Case_Title="xge_read_phy_register"
    ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}
    mii-tool ${remote_fibre1} -v | grep "failed: Invalid argument" > ${HNS_TOP_DIR}/data/log/xge_read_phy_register.txt
    if [ $? -eq 0 ]
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\t xge read phy register fail"
    fi
}

function main()
{
    test_case_switch
}
main
