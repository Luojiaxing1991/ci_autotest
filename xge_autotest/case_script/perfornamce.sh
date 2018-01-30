#!/bin/bash
LOCAL_eth1_IP="192.168.10.10"
LOCAL_eth2_IP="192.168.20.10"

REMOTE_eth1_IP="192.168.10.20"
REMOTE_eth2_IP="192.168.20.20"

BACK_IP="192.168.1.184"

NETEXPORT="eth1 eth2"
THREAD="1 5 10"
IP_TEST_DURATION=20

function DataIntegration()
{
    if [ $SendPyte = "SingleOne" ];then
        echo "Single port one-way ${Net} ${owNum}thread:" >> iperf_log/data_integration.log
        sleep 1
        cat iperf_log/single_one-way_$Net\_$owNum\.log | tail -1 >> iperf_log/data_integration.log
        echo -e "\n" >> iperf_log/data_integration.log
        sleep 1
    elif [ $SendPyte = "SingleTwo" ];then
        echo "Single port two-way ${twNum}thread:" >> iperf_log/data_integration.log
        sleep 1
        cat iperf_log/Single_two-way_eth1_$twNum\.log | tail -1 >> iperf_log/data_integration.log
        cat iperf_log/Single_two-way_eth2_$twNum\.log | tail -1 >> iperf_log/data_integration.log
        echo -e "\n" >> iperf_log/data_integration.log
        sleep 1        
    elif [ $SendPyte = "DualOne" ];then
        echo "Dual port one-way ${Net} ${twNum}thread:" >> iperf_log/data_integration.log
        sleep 1
        cat iperf_log/dual_one-way_local_$Net\_$Num\.log | tail -1 >> iperf_log/data_integration.log
        cat iperf_log/dual_one-way_remote_$Net\_$Num\.log | tail -1 >> iperf_log/data_integration.log
        echo -e "\n" >> iperf_log/data_integration.log
        sleep 1
    else
        echo "Dual port two-way ${twNum}thread:" >> iperf_log/data_integration.log
        sleep 1
        cat iperf_log/dual_twoway_local_eth1_$twNum\.log | tail -1 >> iperf_log/data_integration.log
        cat iperf_log/dual_twoway_remote_eth1_$twNum\.log | tail -1 >> iperf_log/data_integration.log
        cat iperf_log/dual_twoway_local_eth2_$twNum\.log | tail -1 >> iperf_log/data_integration.log
        cat iperf_log/dual_twoway_remote_eth2_$twNum\.log | tail -1 >> iperf_log/data_integration.log        
        echo -e "\n" >> iperf_log/data_integration.log
        sleep 1    
    fi
}

function IperfSingle()
{
    ssh root@$BACK_IP "iperf -s >/dev/null 2>&1 &"
    echo "#############################"
    echo "Run Single port One-way..."
    echo "#############################"    
    SendPyte="SingleOne"
    for Net in $NETEXPORT
    do
        LocalIP=$(eval echo '$'LOCAL_"$Net"_IP)
        RemoteIP=$(eval echo '$'REMOTE_"$Net"_IP)
        ifconfig $Net $LocalIP
        ssh root@$BACK_IP "ifconfig $Net $RemoteIP"
        
        for owNum in $THREAD 
        do
            echo "Run single port $Net ${owNum}thread......"
            iperf -c $RemoteIP -t $IP_TEST_DURATION -i 1 -P $owNum > iperf_log/single_one-way_$Net\_$owNum\.log
            flag=1
            result=1
            while [ "$flag" -eq 1 ]
            do
                sleep 2
                result=`pidof iperf`
                if [ -z "$result" ];then
                    echo "process is finished"
                    flag=0
                fi
            done
            DataIntegration
        done
        sleep 5
    done
    ssh root@$BACK_IP "killall iperf;iperf -s >/dev/null 2>&1 &"
    sleep 5

    #two-way perfornamce
    echo "#############################"
    echo "Run Single port two-way..."
    echo "#############################"
    SendPyte="SingleTwo"
    for twNum in $THREAD
    do
        echo "Run single port two-way ${twNum}thread......"
        iperf -c $REMOTE_eth1_IP -t $IP_TEST_DURATION -i 2 -P $twNum > iperf_log/Single_two-way_eth1_$twNum\.log &
        iperf -c $REMOTE_eth2_IP -t $IP_TEST_DURATION -i 2 -P $twNum > iperf_log/Single_two-way_eth2_$twNum\.log &
        sleep 25
        
        flag=1
        result=1
        while [ "$flag" -eq 1 ]
        do
            sleep 2
            result=`pidof iperf`
            if [ -z "$result" ];then
                echo "process is finished"
                flag=0
            fi
        done
        DataIntegration
    done
}

function IperfDual()
{
    killall iperf
    iperf -s >/dev/null 2>&1 &
    ssh root@$BACK_IP "killall iperf;iperf -s >/dev/null 2>&1 &"
    echo "#############################"
    echo "Run Dual port one-way..."
    echo "#############################"
    SendPyte="DualOne"
    for Net in $NETEXPORT
    do
        LocalIP=$(eval echo '$'LOCAL_"$Net"_IP)
        RemoteIP=$(eval echo '$'REMOTE_"$Net"_IP)
        ifconfig $Net $LocalIP
        ssh root@$BACK_IP "ifconfig $Net $RemoteIP"
        for Num in $THREAD
        do
            echo "Run dual port $Net ${Num}thread......"
            iperf -c $RemoteIP -t $IP_TEST_DURATION -i 1 -P $Num > iperf_log/dual_one-way_local_$Net\_$Num\.log &
            ssh root@$BACK_IP "iperf -c $LocalIP -t $IP_TEST_DURATION -i 1 -P $Num > iperf_log/dual_one-way_remote_$Net\_$Num\.log &"
            sleep $IP_TEST_DURATION
            flag=1
            result=1
            while [ "$flag" -eq 1 ]
            do
                sleep 5
                result=`ps -ef | grep iperf | wc -l`
                if [ "$result" -le 2 ];then
                    echo "process is finished"
                    flag=0
                fi
            done
            DataIntegration
            #cat iperf_log/dual_one-way_local_$Net\_$Num\.log | tail -1 >> iperf_log/data_integration.log 
            #cat iperf_log/dual_one-way_remote_$Net\_$Num\.log | tail -1 >> iperf_log/data_integration.log
        done
        sleep 5
    done

    sleep 5
    echo "#############################"
    echo "Run Dual port two-way..."
    echo "#############################"	
    SendPyte="DualTwo"
    killall iperf
    iperf -s >/dev/null 2>&1 &
    ssh root@$BACK_IP "killall iperf;iperf -s >/dev/null 2>&1 &"	
    for twNum in $THREAD
    do
        echo "Run Two-way ${twNum}thread......"
        iperf -c $REMOTE_eth1_IP -t $IP_TEST_DURATION -i 2 -P $twNum > iperf_log/dual_twoway_local_eth1_$twNum\.log &
        iperf -c $REMOTE_eth2_IP -t $IP_TEST_DURATION -i 2 -P $twNum > iperf_log/dual_twoway_local_eth2_$twNum\.log &
	ssh root@$BACK_IP "iperf -c $LOCAL_eth1_IP -t $IP_TEST_DURATION -i 2 -P $twNum > iperf_log/dual_twoway_remote_eth1_$twNum\.log &"
	ssh root@$BACK_IP "iperf -c $LOCAL_eth2_IP -t $IP_TEST_DURATION -i 2 -P $twNum > iperf_log/dual_twoway_remote_eth2_$twNum\.log &"
        sleep $IP_TEST_DURATION
        flag=1
        result=1
        while [ "$flag" -eq 1 ]
        do
            sleep 5
            result=`ps -ef | grep iperf | wc -l`
            if [ "$result" -le 2 ];then
	    echo "process is finished"
	    flag=0
	    fi
	done
        DataIntegration
        #cat iperf_log/dual_twoway_local_eth1_$twNum\.log | tail -1 >> iperf_log/data_integration.log
        #cat iperf_log/dual_twoway_local_eth2_$twNum\.log | tail -1 >> iperf_log/data_integration.log
        #cat iperf_log/dual_twoway_remote_eth1_$twNum\.log | tail -1 >> iperf_log/data_integration.log
        #cat iperf_log/dual_twoway_remote_eth2_$twNum\.log | tail -1 >> iperf_log/data_integration.log
    done
}
rm iperf_log/*.log
IperfSingle
sleep 5
IperfDual
sleep 5
killall iperf
ssh root@192.168.1.184 "killall iperf"

