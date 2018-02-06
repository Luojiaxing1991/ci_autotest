#!/bin/bash

# enable and disable interface
# IN :N/A
# OUT:N/A
#!/bin/bash

# enable and disable interface
# IN :N/A
# OUT:N/A
function enable_and_disable_interface()
{
    Test_Case_Title="enable_and_disable_interface"
    echo "Begin to Run "${Test_Case_Title}
    ifconfig $local_tp2 up; ifconfig $local_tp2 192.168.10.10
    ssh root@$BACK_IP "ifconfig ${remote_tp2} up;ifconfig ${remote_tp2} 192.168.10.20; sleep 5"
    ping 192.168.10.20 -c 5 > ${XGE_TOP_DIR}/data/log/enable_and_disable_interface.txt &
    sleep 10
    cat ${XGE_TOP_DIR}/data/log/enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 0 ];then
       enableok=1
    fi
    ssh root@$BACK_IP "ifconfig $remote_tp2 down"
    ping 192.168.10.20 -c 5 > ${XGE_TOP_DIR}/data/log/enable_and_disable_interface.txt &
    sleep 10
    cat ${XGE_TOP_DIR}/data/log/enable_and_disable_interface.txt | grep "received, 0% packet loss" >/dev/null
    if [ $? -eq 1 ];then
       disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
	echo "EN/DIS interface is Success!"
        MESSAGE="PASS"
    else
	echo "En/DIS interface is Fail"
        MESSAGE="FAIL\tNet export up/down , Ping packet failure"
    fi
}

function continued_enable_and_disable_interface()
{
    i=1
    Test_Case_Title="Continued_enable_and_disable_interface"
    echo "Begin to Run "${Test_Case_Title}

    while(($i<=10))
    do
        ifconfig $local_eth1 up; ifconfig $local_eth1 192.168.100.212
        ssh root@$BACK_IP "ifconfig $remote_eth1 up; ifconfig $remote_eth1 192.168.100.200; sleep 5"
        ping 192.168.100.200 -c 5 > ${XGE_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt &
        sleep 10
        cat ${XGE_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt | grep "0% packet loss" >/dev/null
        if [ $? -eq 0 ];then
           enableok=1
        fi
        ssh root@$BACK_IP "ifconfig $remote_eth1 down"
        ping 192.168.100.200 -c 5 > ${XGE_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt &
        sleep 10
        cat ${XGE_TOP_DIR}/data/log/continued_enable_and_disable_interface.txt | grep "0% packet loss" >/dev/null
        if [ $? -eq 1 ];then
           disableok=1
        fi
        i=$(($i+1))
    done
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        writePass
    else
        writeFail
    fi
}

function flow_enable_and_disable_interface()
{
    ifconfig $local_eth1 up; ifconfig $local_eth1 192.168.100.212
    ssh root@$BACK_IP "ifconfig eth1 up; ifconfig eth1 192.168.100.200; sleep 5"
    ping 192.168.100.200 > ${XGE_TOP_DIR}/data/log/flow_enable_and_disable_interface.txt &
    PacketStatistics1=`ifconfig eth1 | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    sleep 10
    PacketStatistics2=`ifconfig eth1 | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    if [ $PacketStatistics2 > $PacketStatistics1 ];then
        enableok=1
    fi

    ssh root@$BACK_IP "ifconfig eth1 down"
    PacketStatistics1=`ifconfig eth1 | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    sleep 10
    PacketStatistics2=`ifconfig eth1 | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
    if [ $PacketStatistics2 = $PacketStatistics1 ];then
        disableok=1
    fi
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        writePass
    else
        writeFail
    fi
    killall ping
}

function flow_continued_enable_and_disable_interface()
{
    ifconfig $local_eth1 up; ifconfig $local_eth1 192.168.100.212
    ssh root@$BACK_IP 'ifconfig eth1 up; ifconfig eth1 192.168.100.200; sleep 5;'
    ping 192.168.100.200 > ${XGE_TOP_DIR}/data/log/flow_continued_enable_and_disable_interface.txt &
    i=1
    while(($i<=10))
    do
        ssh root@$BACK_IP 'ifconfig eth1 up'
        PacketStatistics1=`ifconfig eth1 | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        sleep 10
        PacketStatistics2=`ifconfig eth1 | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        if [ $PacketStatistics2 > $PacketStatistics1 ];then
            enableok=1
        fi

        ssh root@$BACK_IP 'ifconfig eth1 down;'
        PacketStatistics1=`ifconfig eth1 | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        sleep 10
        PacketStatistics2=`ifconfig eth1 | grep "RX packets:" | awk -F":" '{print $2}' | awk '{print $1}'`
        if [ $PacketStatistics2 = $PacketStatistics1 ];then
            disableok=1
        fi
        i=$(($i+1))
    done
    if [ $enableok -eq 1 -a $disableok -eq 1 ];then
        writePass
    else
        writeFail
    fi
    killall ping
}

#function flow_continued_enable_and_disable_interface()

function main()
{
    if [ x"${TEST_CASE_FUNCTION_SWITCH}" == x"on" ]
    then
        ${TEST_CASE_FUNCTION_NAME}
    else
        MESSAGE="BLOCK\tno automated use cases were implemented."
    fi


    #:>${XGE_TOP_DIR}/data/log/enable_and_disable_interface.txt
    #enable_and_disable_interface
    #continued_enable_and_disable_interface
    #flow_enable_and_disable_interface
    #flow_continued_enable_and_disable_interface
}

main
