#!/bin/bash
LOG_DIR="perf_log"
IPERFDIR="iperf_log"
NETPERFDIR="netperf_log"
QPERFDIR="qperf_log"

NETPORT1="$remote_tp1"
NETPORT2="$remote_fibre2"
NETPORTLIST="$remote_tp1 $remote_fibre2"

#ipv6 config

#iperf config
THREAD="1 5 10"
IPERFDURATION=20

#netperf config
NETPERFDURATION=5
STREAM_TYPE="TCP_STREAM UDP_STREAM"
RR_TYPE="TCP_RR TCP_CRR UDP_RR"
TCP_MSS="32 64 128 256 512 1024 1500"
UDP_MSS="32 64 128 256 521 1024 4096 16376 32753 65507"


function usage()
{
    echo "$0 all | iperf | qperf | netperf | ipv6_iperf"
}

function prepare_log_dir()
{
    if [ ! -d $LOG_DIR ]; then
        mkdir $LOG_DIR
    fi
    for log_type in iperf_log qperf_log netperf_log
    do
        if [ ! -d $LOG_DIR/$log_type ]; then
            mkdir $LOG_DIR/$log_type
        else
            rm $LOG_DIR/$log_type/*.log
        fi
    done
}

function data_integration()
{
    if [ $SendPyte = "SingleOne" ];then
        echo "Single port one-way ${netport} ${owNum}thread:" >> $LOG_DIR/$IPERFDIR/data_integration.log
        sleep 1
        cat $LOG_DIR/$IPERFDIR/single_one-way_${netport}_${owNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/data_integration.log
        echo -e "\n" >> $LOG_DIR/$IPERFDIR/data_integration.log
        sleep 1
    elif [ $SendPyte = "SingleTwo" ];then
        echo "Single port two-way ${twNum}thread:" >> $LOG_DIR/$IPERFDIR/data_integration.log
        sleep 1
        cat $LOG_DIR/$IPERFDIR/Single_two-way_${NETPORT1}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/data_integration.log
        cat $LOG_DIR/$IPERFDIR/Single_two-way_${NETPORT2}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/data_integration.log
        echo -e "\n" >> $LOG_DIR/$IPERFDIR/data_integration.log
        sleep 1
    elif [ $SendPyte = "DualOne" ];then
        echo "Dual port one-way ${netport} ${owNum}thread:" >> $LOG_DIR/$IPERFDIR/data_integration.log
        sleep 1
        cat $LOG_DIR/$IPERFDIR/dual_one-way_local_${netport}_${owNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/data_integration.log
        cat $LOG_DIR/$IPERFDIR/dual_one-way_remote_${netport}_${owNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/data_integration.log
        echo -e "\n" >> $LOG_DIR/$IPERFDIR/data_integration.log
        sleep 1
    else
        echo "Dual port two-way ${twNum}thread:" >> $LOG_DIR/$IPERFDIR/data_integration.log
        sleep 1
        cat $LOG_DIR/$IPERFDIR/dual_twoway_local_${NETPORT1}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/data_integration.log
        cat $LOG_DIR/$IPERFDIR/dual_twoway_remote_${NETPORT1}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/data_integration.log
        cat $LOG_DIR/$IPERFDIR/dual_twoway_local_${NETPORT2}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/data_integration.log
        cat $LOG_DIR/$IPERFDIR/dual_twoway_remote_${NETPORT2}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/data_integration.log
        echo -e "\n" >> $LOG_DIR/$IPERFDIR/data_integration.log
        sleep 1    
    fi  
} 

function check_single_process()
{
    flag=1
    result=1
    while [ "$flag" -eq 1 ]
    do
        sleep 1
        result=`pidof $process`
        if [ -z "$result" ];then
            echo "$process process is finished"
            flag=0
        fi
    done
}

function check_dual_process()
{
    flag=1
    result=1
    while [ "$flag" -eq 1 ]
    do
        sleep 2
        result=`ps -ef | grep $process | wc -l`
        if [ "$result" -le 2 ];then
            echo "$process process is finished"
            flag=0
        fi
    done
}

function ipv6_data_integration()
{
    if [ $SendPyte = "SingleOne" ];then
        echo "Single port one-way ${netport} ${owNum}thread:" >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        sleep 1
        cat $LOG_DIR/$IPERFDIR/Ipv6_single_one-way_${netport}_${owNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        echo -e "\n" >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        sleep 1
    elif [ $SendPyte = "SingleTwo" ];then
        echo "Single port two-way ${twNum}thread:" >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        sleep 1
        cat $LOG_DIR/$IPERFDIR/Ipv6_Single_two-way_${NETPORT1}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        cat $LOG_DIR/$IPERFDIR/Ipv6_Single_two-way_${NETPORT2}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        echo -e "\n" >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        sleep 1
    elif [ $SendPyte = "DualOne" ];then
        echo "Dual port one-way ${netport} ${owNum}thread:" >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        sleep 1
        cat $LOG_DIR/$IPERFDIR/Ipv6_dual_one-way_local_${netport}_${owNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        cat $LOG_DIR/$IPERFDIR/Ipv6_dual_one-way_remote_${netport}_${owNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        echo -e "\n" >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        sleep 1
    else
        echo "Dual port two-way ${twNum}thread:" >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        sleep 1
        cat $LOG_DIR/$IPERFDIR/Ipv6_dual_twoway_local_${NETPORT1}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        cat $LOG_DIR/$IPERFDIR/Ipv6_dual_twoway_remote_${NETPORT1}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        cat $LOG_DIR/$IPERFDIR/Ipv6_dual_twoway_local_${NETPORT2}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        cat $LOG_DIR/$IPERFDIR/Ipv6_dual_twoway_remote_${NETPORT2}_${twNum}thread.log | tail -1 >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        echo -e "\n" >> $LOG_DIR/$IPERFDIR/Ipv6_data_integration.log
        sleep 1    
    fi  
}

function ipv6_iperf_single()
{ 
    REMOTE1_IPV6_IP=$(ssh root@$BACK_IP "ifconfig ${remote_fibre1} | grep 'inet6 addr:' | awk '{print \$3}' | awk -F'/' '{print \$1}' | head -n 1")
    REMOTE2_IPV6_IP=$(ssh root@$BACK_IP "ifconfig ${remote_fibre2} | grep 'inet6 addr:' | awk '{print \$3}' | awk -F'/' '{print \$1}' | head -n 1")
    process="iperf"
    ssh root@$BACK_IP "iperf -s -V >/dev/null 2>&1 &"
    echo "#############################"
    echo "Run iperf Single port One-way..."
    echo "#############################"    
    SendPyte="SingleOne"

    for netport in $NETPORTLIST
    do
        if [ ${netport} == ${NETPORT1} ];then
            for owNum in $THREAD
            do
                echo "Run single port $netport ${owNum}thread......"
                iperf -c ${REMOTE1_IPV6_IP}%${netport} -V -t $IPERFDURATION -i 2 -P $owNum > $LOG_DIR/$IPERFDIR/Ipv6_single_one-way_${netport}_${owNum}thread.log
                check_single_process
                ipv6_data_integration
            done
            sleep 5
        else
            for owNum in $THREAD
            do
                echo "Run single port $netport ${owNum}thread......"
                iperf -c ${REMOTE2_IPV6_IP}%${netport} -V -t $IPERFDURATION -i 1 -P $owNum > $LOG_DIR/$IPERFDIR/Ipv6_single_one-way_${netport}_${owNum}thread.log
                check_single_process
                ipv6_data_integration
            done
            sleep 5
        fi
    done
    sleep 5

    #two-way perfornamce
    ssh root@$BACK_IP "killall iperf;iperf -s -V >/dev/null 2>&1 &"
    echo "#############################"
    echo "Run iperf Single port two-way..."
    echo "#############################"
    SendPyte="SingleTwo"
    for twNum in $THREAD
    do
        echo "Run single port two-way ${twNum}thread......"
        iperf -c ${REMOTE1_IPV6_IP}%${remote_fibre1_ip} -V -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/Ipv6_Single_two-way_${NETPORT1}_${twNum}thread.log &
        iperf -c ${REMOTE2_IPV6_IP}%${remote_fibre2_ip} -V -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/Ipv6_Single_two-way_${NETPORT2}_${twNum}thread.log &
        sleep 25
        check_single_process
        ipv6_data_integration
    done
}

function ipv6_iperf_dual()
{
    LOCAL1_IPV6_IP=$(ifconfig ${local_fibre1_ip} | grep 'inet6 addr:' | awk '{print $3}' | awk -F'/' '{print $1}' | head -n 1)
    LOCAL2_IPV6_IP=$(ifconfig ${local_fibre2_ip} | grep 'inet6 addr:' | awk '{print $3}' | awk -F'/' '{print $1}' | head -n 1)
    REMOTE1_IPV6_IP=$(ssh root@$BACK_IP "ifconfig ${remote_fibre1_ip} | grep 'inet6 addr:' | awk '{print \$3}' | awk -F'/' '{print \$1}' | head -n 1")
    REMOTE2_IPV6_IP=$(ssh root@$BACK_IP "ifconfig ${remote_fibre2_ip} | grep 'inet6 addr:' | awk '{print \$3}' | awk -F'/' '{print \$1}' | head -n 1")
    process="iperf"
    killall iperf
    iperf -s -V >/dev/null 2>&1 &
    ssh root@$BACK_IP "killall iperf;iperf -s -V >/dev/null 2>&1 &"
    echo "#############################"
    echo "Run iperf Dual port one-way..."
    echo "#############################"
    SendPyte="DualOne"
    for netport in $NETPORTLIST
    do
        if [ ${netport} == ${NETPORT1} ];then
            for owNum in $THREAD
            do
                echo "Run dual port ${netport} ${owNum}thread......"
                iperf -c ${REMOTE1_IPV6_IP}%${netport} -V -t $IPERFDURATION -i 2 -P ${owNum} > $LOG_DIR/$IPERFDIR/Ipv6_dual_one-way_local_${netport}_${owNum}thread.log &
                ssh root@$BACK_IP "iperf -c ${LOCAL1_IPV6_IP}%${local_fibre1_ip} -V -t $IPERFDURATION -i 2 -P ${owNum} > $LOG_DIR/$IPERFDIR/Ipv6_dual_one-way_remote_${netport}_${owNum}thread.log &"
                sleep $IPERFDURATION
                check_dual_process
                ipv6_data_integration
            done
            sleep 5
        else
            for owNum in $THREAD
            do
                echo "Run dual port $netport ${owNum}thread......"
                iperf -c ${REMOTE2_IPV6_IP}%${netport} -V -t $IPERFDURATION -i 2 -P $owNum > $LOG_DIR/$IPERFDIR/Ipv6_dual_one-way_local_${netport}_${owNum}thread.log &
                ssh root@$BACK_IP "iperf -c ${LOCAL2_IPV6_IP}%${local_fibre2_ip} -V -t $IPERFDURATION -i 2 -P $owNum > $LOG_DIR/$IPERFDIR/Ipv6_dual_one-way_remote_${netport}_${owNum}thread.log &"
                sleep $IPERFDURATION
                check_dual_process
                ipv6_data_integration
            done
            sleep 5
        fi
    done
    sleep 5

    echo "#############################"
    echo "Run iperf Dual port two-way..."
    echo "#############################"
    SendPyte="DualTwo"
    killall iperf
    iperf -s -V >/dev/null 2>&1 &
    ssh root@$BACK_IP "killall iperf;iperf -s -V >/dev/null 2>&1 &"
    for twNum in $THREAD
    do
        echo "Run Two-way ${twNum}thread......"
        iperf -c ${REMOTE1_IPV6_IP}%${remote_fibre1_ip} -V -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/Ipv6_dual_twoway_local_${NETPORT1}_${twNum}thread.log &
        iperf -c ${REMOTE2_IPV6_IP}%${remote_fibre2_ip} -V -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/Ipv6_dual_twoway_local_${NETPORT2}_${twNum}thread.log &
        ssh root@$BACK_IP "iperf -c ${LOCAL1_IPV6_IP}%${local_fibre1_ip} -V -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/Ipv6_dual_two-way_remote_${NETPORT1}_${twNum}thread.log &"
        ssh root@$BACK_IP "iperf -c ${LOCAL2_IPV6_IP}%${local_fibre2_ip} -V -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/Ipv6_dual_two-way_remote_${NETPORT2}_${twNum}thread.log &"
        sleep $IPERFDURATION
        check_dual_process
        ipv6_data_integration
    done
}

function iperf_single()
{
    process="iperf"
    killall iperf
    ssh root@$BACK_IP "killall iperf;iperf -s >/dev/null 2>&1 &"
    echo "#############################"
    echo "Run iperf Single port One-way..."
    echo "#############################"    
    SendPyte="SingleOne"

    for netport in $NETPORTLIST
    do
        if [ ${netport} == ${NETPORT1} ];then
            for owNum in $THREAD
            do
                echo "Run single port $netport ${owNum}thread......"
                iperf -c ${remote_tp1_ip} -t $IPERFDURATION -i 2 -P $owNum > $LOG_DIR/$IPERFDIR/single_one-way_${netport}_${owNum}thread.log
                check_single_process
                data_integration
            done
            sleep 5
        else
            for owNum in $THREAD
            do
                echo "Run single port $netport ${owNum}thread......"
               # iperf -c ${remote_fibre2_ip} -t $IPERFDURATION -i 1 -P $owNum > $LOG_DIR/$IPERFDIR/single_one-way_${netport}_${owNum}thread.log
               # check_single_process
               # data_integration
            done
            sleep 5
        fi
    done
    sleep 5
    if [ "ss" = "fefe"  ];then
    #two-way perfornamce
      ssh root@$BACK_IP "killall iperf;iperf -s >/dev/null 2>&1 &"
      echo "#############################"
      echo "Run iperf Single port two-way..."
      echo "#############################"
      SendPyte="SingleTwo"
      for twNum in $THREAD
      do
        echo "Run single port two-way ${twNum}thread......"
        iperf -c ${remote_fibre1_ip} -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/Single_two-way_${NETPORT1}_${twNum}thread.log &
        iperf -c ${remote_fibre2_ip} -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/Single_two-way_${NETPORT2}_${twNum}thread.log &
        sleep 25
        check_single_process
        data_integration
      done
    fi
}

function iperf_dual()
{
    process="iperf"
    killall iperf
    iperf -s >/dev/null 2>&1 &
    ssh root@$BACK_IP "killall iperf;iperf -s >/dev/null 2>&1 &"
    echo "#############################"
    echo "Run iperf Dual port one-way..."
    echo "#############################"
    SendPyte="DualOne"
    for netport in $NETPORTLIST
    do
        if [ ${netport} == ${NETPORT1} ];then
            for owNum in $THREAD
            do
                echo "Run dual port ${netport} ${owNum}thread......"
                iperf -c ${remote_fibre1_ip} -t $IPERFDURATION -i 2 -P ${owNum} > $LOG_DIR/$IPERFDIR/dual_one-way_local_${netport}_${owNum}thread.log &
                ssh root@$BACK_IP "iperf -c ${local_fibre1_ip} -t $IPERFDURATION -i 2 -P ${owNum} > $LOG_DIR/$IPERFDIR/dual_one-way_remote_${netport}_${owNum}thread.log &"
                sleep $IPERFDURATION
                check_dual_process
                data_integration
            done
            sleep 5
        else
            for owNum in $THREAD
            do
                echo "Run dual port $netport ${owNum}thread......"
                iperf -c ${remote_fibre2_ip} -t $IPERFDURATION -i 2 -P $owNum > $LOG_DIR/$IPERFDIR/dual_one-way_local_${netport}_${owNum}thread.log &
                ssh root@$BACK_IP "iperf -c ${local_fibre2_ip} -t $IPERFDURATION -i 2 -P $owNum > $LOG_DIR/$IPERFDIR/dual_one-way_remote_${netport}_${owNum}thread.log &"
                sleep $IPERFDURATION
                check_dual_process
                data_integration
            done
            sleep 5
        fi
    done
    sleep 5

    echo "#############################"
    echo "Run iperf Dual port two-way..."
    echo "#############################"
    SendPyte="DualTwo"
    killall iperf
    iperf -s >/dev/null 2>&1 &
    ssh root@$BACK_IP "killall iperf;iperf -s >/dev/null 2>&1 &"
    for twNum in $THREAD
    do
        echo "Run Two-way ${twNum}thread......"
        iperf -c ${remote_fibre1_ip} -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/dual_twoway_local_${NETPORT1}_${twNum}thread.log &
        iperf -c ${remote_fibre2_ip} -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/dual_twoway_local_${NETPORT2}_${twNum}thread.log &
        ssh root@$BACK_IP "iperf -c ${local_fibre1_ip} -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/dual_twoway_remote_${NETPORT1}_${twNum}thread.log &"
        ssh root@$BACK_IP "iperf -c ${local_fibre2_ip} -t $IPERFDURATION -i 2 -P $twNum > $LOG_DIR/$IPERFDIR/dual_twoway_remote_${NETPORT2}_${twNum}thread.log &"
        sleep $IPERFDURATION
        check_dual_process
        data_integration
    done
}

function netperf_single()
{
    echo "#############################"
    echo "Run netperf Single port TCP/UDP STREAM..."
    echo "#############################"
    process="netperf"
    ssh root@$BACK_IP "killall netserver;netserver >/dev/null 2>&1 &"
    for netport in ${NETPORTLIST}
    do
        if [ ${netport} == ${NETPORT1} ];then
            for tcpnum in ${TCP_MSS}
            do
                echo "Run Single port $netport TCP_STREAM $tcpnum Message Size(bytes)..."
                netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t TCP_STREAM -- -m ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_STREAM.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_STREAM.log
                
                echo "Run Single port $netport TCP_RR $tcpnum Message Size(bytes)..."
                netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t TCP_RR -- -r ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_RR.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_RR.log
                
                echo "Run Single port $netport TCP_CRR $tcpnum Message Size(bytes)..."
                netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t TCP_CRR -- -r ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_CRR.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_CRR.log
            done

            for udpnum in ${UDP_MSS}
            do
                echo "Run Single port $netport UDP_STREAM $udpnum Message Size(bytes)..."
                netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t UDP_STREAM -- -m ${udpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_UDP_STREAM.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_UDP_STREAM.log
                
                echo "Run Single port $netport UDP_RR $udpnum Message Size(bytes)..."
                netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t UDP_RR -- -r ${udpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_UDP_RR.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_UDP_RR.log
            done
        else
            for tcpnum in ${TCP_MSS}
            do
                echo "Run Single port $netport TCP_STREAM $tcpnum Message Size(bytes)..."
                netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t TCP_STREAM -- -m ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_STREAM.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_STREAM.log
                
                echo "Run Single port $netport TCP_RR $tcpnum Message Size(bytes)..."
                netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t TCP_RR -- -r ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_RR.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_RR.log
                
                echo "Run Single port $netport TCP_CRR $tcpnum Message Size(bytes)..."
                netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t TCP_CRR -- -r ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_CRR.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_TCP_CRR.log
            done

            for udpnum in ${UDP_MSS}
            do
                echo "Run Single port $netport UDP_STREAM $udpnum Message Size(bytes)..."
                netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t UDP_STREAM -- -m ${udpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_UDP_STREAM.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_UDP_STREAM.log
                
                echo "Run Single port $netport UDP_RR $udpnum Message Size(bytes)..."
                netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t UDP_RR -- -r ${udpnum} >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_UDP_RR.log
                check_single_process
                echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Single_port_${netport}_UDP_RR.log
            done
        fi
    done
}

function netperf_dual
{
    echo "#############################"
    echo "Run netperf dual port TCP/UDP Message..."
    echo "#############################"
    process="netperf"
    ssh root@$BACK_IP "killall netserver;netserver >/dev/null 2>&1 &"

    for tcpnum in ${TCP_MSS}
    do
        echo "Run dual port TCP_STREAM $tcpnum Message Size(bytes)..."
        netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t TCP_STREAM -- -m ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_TCP_STREAM.log &
        netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t TCP_STREAM -- -m ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_TCP_STREAM.log &
        sleep ${NETPERFDURATION}
        check_single_process
        echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Dual_port_TCP_STREAM.log
        
        echo "Run dual port TCP_RR $tcpnum Message Size(bytes)..."
        netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t TCP_RR -- -r ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_TCP_RR.log &
        netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t TCP_RR -- -r ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_TCP_RR.log &
        sleep ${NETPERFDURATION}
        check_single_process
        echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Dual_port_TCP_RR.log
        
        echo "Run dual port TCP_CRR $tcpnum Message Size(bytes)..."
        netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t TCP_CRR -- -r ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_TCP_CRR.log &
        netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t TCP_CRR -- -r ${tcpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_TCP_CRR.log &
        sleep ${NETPERFDURATION}
        check_single_process
        echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Dual_port_TCP_CRR.log
    done
    
    for udpnum in ${UDP_MSS}
    do
        echo "Run dual port UDP_STREAM $udpnum Message Size(bytes)..."
        netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t UDP_STREAM -- -m ${udpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_UDP_STREAM.log &
        netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t UDP_STREAM -- -m ${udpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_UDP_STREAM.log &
        sleep ${NETPERFDURATION}
        check_single_process
        echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Dual_port_UDP_STREAM.log
        
        echo "Run dual port UDP_RR $udpnum Message Size(bytes)..."
        netperf -H ${remote_fibre1_ip} -l ${NETPERFDURATION} -t UDP_RR -- -r ${udpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_UDP_RR.log &
        netperf -H ${remote_fibre2_ip} -l ${NETPERFDURATION} -t UDP_RR -- -r ${udpnum} >> $LOG_DIR/$NETPERFDIR/Dual_port_UDP_RR.log &
        sleep ${NETPERFDURATION}
        check_single_process
        echo -e "\n" >> $LOG_DIR/$NETPERFDIR/Dual_port_UDP_RR.log
    done
}


function qperf_test()
{
    echo "#############################"
    echo "Run qperf test..."
    echo "#############################"
    process="qperf"
    ssh root@$BACK_IP "killall qperf;qperf >/dev/null 2>&1 &"
    for netport in ${NETPORTLIST}
    do
        if [ ${netport} == ${NETPORT1} ];then
            echo "Run Single port $netport qperf TCP..."
            qperf ${remote_fibre1_ip} -oo msg_size:1:64K:*2 -vu tcp_lat tcp_bw >> $LOG_DIR/$QPERFDIR/Single_port_${netport}_tcp.log
            check_single_process
            
            echo "Run Single port $netport qperf UCP..."
            qperf ${remote_fibre1_ip} -oo msg_size:1:64K:*2 -vu udp_lat udp_bw >> $LOG_DIR/$QPERFDIR/Single_port_${netport}_udp.log
            check_single_process
        else
            echo "Run Single port $netport qperf TCP..."
            qperf ${remote_fibre2_ip} -oo msg_size:1:64K:*2 -vu tcp_lat tcp_bw >> $LOG_DIR/$QPERFDIR/Single_port_${netport}_tcp.log
            check_single_process
            
            echo "Run Single port $netport qperf UCP..."
            qperf ${remote_fibre2_ip} -oo msg_size:1:64K:*2 -vu udp_lat udp_bw >> $LOG_DIR/$QPERFDIR/Single_port_${netport}_udp.log
            check_single_process
        fi
    done
}

#if not, create
if [ $# = 0 ];then
	test_type=all;
else
	test_type="$1"
fi

#check the log directory is existed or not.
prepare_log_dir

#ifconfig IP
ifconfig $local_tp1 ${local_tp1_ip}
ifconfig $local_fibr2 ${local_fibre2_ip}
ssh root@$BACK_IP "ifconfig $NETPORT1 ${remote_fibre1_ip};ifconfig $NETPORT2 ${remote_fibre2_ip};"
iperf_single
iperf_dual
ssh root@$BACK_IP "killall iperf" 
   
case $test_type in 
"all")
    echo "testing  iperf ..."
    iperf_single
    iperf_dual
    ssh root@$BACK_IP "killall iperf" 
    echo "testing  qperf ..."
    qperf_test
    echo "testing  netperf ..."
    netperf_single
    netperf_dual
    ssh root@$BACK_IP "killall netserver"
;;
"iperf")
    echo "testing  iperf ..."
    iperf_single
    iperf_dual
    ssh root@$BACK_IP "killall iperf" 
    echo "Complete the iperf test"
;;
"qperf")
    echo "test qperf"
    qperf_test
    ssh root@$BACK_IP "killall qperf"
    echo "Complete the qperf test"
;;
"netperf")
    echo "test netperf"
    netperf_single
    netperf_dual
    ssh root@$BACK_IP "killall netserver"
    echo "Complete the netserver test"
;;
"ipv6_iperf")
    echo "test ipv6"
    ipv6_iperf_single
    ipv6_iperf_dual
    ssh root@$BACK_IP "killall iperf"
    echo "Complete the ipv6_iperf test"
;;
*)
    echo "Unknow argument"
    usage
    exit
;;
esac


