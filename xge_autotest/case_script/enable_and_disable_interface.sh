#!/bin/bash

# enable and disable interface
# IN :N/A
# OUT:N/A
#!/bin/bash

# enable and disable interface
# IN :N/A
# OUT:N/A
function ge_enable_and_disable_interface()
{
    echo "Begin to Run "${Test_Case_Title}

    Test_Case_Title="ge_enable_and_disable_interface"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_tp1} up;ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5"
    ping ${remote_tp1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/enable_and_disable_interface.txt &
    sleep 10
    enableok=0
    disableok=0
    cat ${HNS_TOP_DIR}/data/log/enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
       enableok=1
    fi
    echo "enableok "${enableok}
    ssh root@$BACK_IP "ifconfig ${remote_tp1} down"
    ping ${remote_tp1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/enable_and_disable_interface.txt &
    sleep 10
    cat ${HNS_TOP_DIR}/data/log/enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 1 ];then
       disableok=1
    fi
    echo "disableok "${disableok}
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
	echo "EN/DIS interface is Success!"
        MESSAGE="PASS"
    else
	echo "En/DIS interface is Fail"
        MESSAGE="FAIL\tNet export up/down , Ping packet failure"
    fi
}

function ge_continued_enable_and_disable_interface()
{
    i=1
    Test_Case_Title="Continued_enable_and_disable_interface"
    echo "Begin to Run "${Test_Case_Title}
    MESSAGE="PASS"
    while(($i<=10))
    do
        echo "begin cycle "$i
        ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
        ssh root@$BACK_IP "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5"
        ping ${remote_tp1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt &
        sleep 10
        cat ${HNS_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
        if [ $? -eq 0 ];then
           enableok=1
        else
           enableok=0
        fi
        ssh root@$BACK_IP "ifconfig ${remote_tp1} down"
        ping ${remote_tp1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt &
        sleep 10
        cat ${HNS_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
        if [ $? -eq 1 ];then
           disableok=1
        else
           disableok=0
        fi
        if [ $enableok -eq 0 -o $disableok -eq 0 ];then
            MESSAGE="FAIL\tNet export many times up/down , Ping packet failure"
            break
        fi
        echo "${MESSAGE}"
        i=$(($i+1))
    done
    #MESSAGE="PASS"
}

function ge_flow_enable_and_disable_interface()
{
    Test_Case_Title="ge_flow_enable_and_disable_interface"
    enableok=0
    disableok=0
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@$BACK_IP "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5"
    ping ${remote_tp1_ip} > ${HNS_TOP_DIR}/data/log/flow_enable_and_disable_interface.txt &
    PacketStatistics1=`ifconfig ${remote_tp1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    sleep 10
    PacketStatistics2=`ifconfig ${remote_tp1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    if [ $PacketStatistics2 -gt $PacketStatistics1 ];then
        enableok=1
    fi

    ssh root@$BACK_IP "ifconfig ${remote_tp1} down"
    PacketStatistics1=`ifconfig ${remote_tp1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    sleep 10
    PacketStatistics2=`ifconfig ${remote_tp1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    if [ $PacketStatistics2 -eq $PacketStatistics1 ];then
        disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        killall ping
        MESSAGE="PASS"
    else
        killall ping
        MESSAGE="FAIL\tNet export many times up/down , Ping packet failure"
    fi
}

function ge_flow_continued_enable_and_disable_interface()
{
    Test_Case_Title="ge_flow_continued_enable_and_disable_interface"
    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@$BACK_IP "ifconfig ${remote_tp1} up; ifconfig ${remote_tp1} ${remote_tp1_ip}; sleep 5;"
    ping ${remote_tp1_ip} > ${HNS_TOP_DIR}/data/log/flow_continued_enable_and_disable_interface.txt &
    i=1
    enableok=0
    disableok=0
    while(($i<=10))
    do
        ssh root@$BACK_IP "ifconfig ${remote_tp1} up;sleep 2"
        PacketStatistics1=`ifconfig ${remote_tp1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        sleep 10
        PacketStatistics2=`ifconfig ${remote_tp1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        if [ $PacketStatistics2 -gt $PacketStatistics1 ];then
            enableok=1
        fi

        ssh root@$BACK_IP "ifconfig ${remote_tp1} down;sleep 2"
        PacketStatistics1=`ifconfig ${remote_tp1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        sleep 10
        PacketStatistics2=`ifconfig ${remote_tp1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        if [ $PacketStatistics2 -eq $PacketStatistics1 ];then
            disableok=1
        fi
        if [ $enableok -eq 0 -o $disableok -eq 0 ];then
            killall ping
            MESSAGE="FAIL\tNet export many times up/down , Ping packet failure"
            break
        fi
        i=$(($i+1))
    done
    killall ping
    MESSAGE="PASS"
}


####### XGE net export up/down test #######
function xge_enable_and_disable_interface()
{
    Test_Case_Title="xge_enable_and_disable_interface"
    ifconfig ${local_fibre1} up; ifconfig ${local_fibre1} ${local_fibre1_ip}
    ssh root@${BACK_IP} "ifconfig ${remote_fibre1} up;ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5"
    ping ${remote_fibre1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/enable_and_disable_interface.txt &
    sleep 10
    enableok=0
    disableok=0

    cat ${HNS_TOP_DIR}/data/log/enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
       enableok=1
    fi
    ssh root@$BACK_IP "ifconfig ${remote_fibre1} down"
    ping ${remote_fibre1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/enable_and_disable_interface.txt &
    sleep 10
    cat ${HNS_TOP_DIR}/data/log/enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 1 ];then
       disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        MESSAGE="PASS"
    else
        MESSAGE="FAIL\tNet export up/down , Ping packet failure"
    fi
}

function xge_continued_enable_and_disable_interface()
{
    Test_Case_Title="xge_continued_enable_and_disable_interface"
    i=1
    enableok=0
    disableok=0

    while(($i<=10))
    do
        ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
        ssh root@$BACK_IP "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5"
        ping ${remote_fibre1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt &
        sleep 10
        cat ${HNS_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
        if [ $? -eq 0 ];then
           enableok=1
        fi
        ssh root@$BACK_IP "ifconfig ${remote_fibre1} down"
        ping ${remote_fibre1_ip} -c 5 > ${HNS_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt &
        sleep 10
        cat ${HNS_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
        if [ $? -eq 1 ];then
           disableok=1
        fi
        if [ $enableok -eq 0 -o $disableok -eq 0 ];then
            MESSAGE="FAIL\tNet export many times up/down , Ping packet failure"
            break
        fi
        i=$(($i+1))
    done
    MESSAGE="PASS"
}

function xge_flow_enable_and_disable_interface()
{
    Test_Case_Title="xge_flow_enable_and_disable_interface"
    enableok=0
    disableok=0

    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@$BACK_IP "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5"
    ping ${remote_fibre1_ip} > ${HNS_TOP_DIR}/data/log/flow_enable_and_disable_interface.txt &
    PacketStatistics1=`ifconfig ${remote_fibre1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    sleep 10
    PacketStatistics2=`ifconfig ${remote_fibre1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    if [ $PacketStatistics2 -gt $PacketStatistics1 ];then
        enableok=1
    fi

    ssh root@$BACK_IP "ifconfig ${remote_fibre1} down"
    PacketStatistics1=`ifconfig ${remote_fibre1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    sleep 10
    PacketStatistics2=`ifconfig ${remote_fibre1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    if [ $PacketStatistics2 -eq $PacketStatistics1 ];then
        disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        killall ping
        MESSAGE="PASS"
    else
        killall ping
        MESSAGE="FAIL\tNet export many times up/down , Ping packet failure"
    fi
}

function xge_flow_continued_enable_and_disable_interface()
{
    Test_Case_Title="xge_flow_continued_enable_and_disable_interface"
    enableok=0
    disableok=0

    ifconfig ${local_tp1} up; ifconfig ${local_tp1} ${local_tp1_ip}
    ssh root@$BACK_IP "ifconfig ${remote_fibre1} up; ifconfig ${remote_fibre1} ${remote_fibre1_ip}; sleep 5;"
    ping ${remote_fibre1_ip} > ${HNS_TOP_DIR}/data/log/flow_continued_enable_and_disable_interface.txt &
    i=1
    while(($i<=10))
    do
        ssh root@$BACK_IP "ifconfig ${remote_fibre1} up;sleep 2"
        PacketStatistics1=`ifconfig ${remote_fibre1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        sleep 10
        PacketStatistics2=`ifconfig ${remote_fibre1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        if [ $PacketStatistics2 -gt $PacketStatistics1 ];then
            enableok=1
        fi

        ssh root@$BACK_IP "ifconfig ${remote_fibre1} down;sleep 2"
        PacketStatistics1=`ifconfig ${remote_fibre1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        sleep 10
        PacketStatistics2=`ifconfig ${remote_fibre1} | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        if [ $PacketStatistics2 -eq $PacketStatistics1 ];then
            disableok=1
        fi
        if [ $enableok -eq 0 -o $disableok -eq 0 ];then
            killall ping
            MESSAGE="FAIL\tNet export many times up/down , Ping packet failure"
            break
        fi
        i=$(($i+1))
    done
    killall ping
    MESSAGE="PASS"
}

function main()
{
    test_case_switch
}
main
