#!/bin/bash


# test bandwidth of GE port
# IN :N/A
# OUT:N/A
function iperf_transfer_test()
{
    Test_Case_Title="iperf_transfer_test"
    Test_Case_ID="ST.FUNC.049/ST.FUNC.050"



    # set ip for two boards
    type=m
    ge_bandwidth=900
    ifconfig eth1 192.168.3.1
    ssh root@$BACK_IP 'ifconfig eth1 192.168.3.2;iperf -s 1>/dev/null &'    
    sleep 5
    for num in ${thread[*]} ;do
    	iperf -c 192.168.3.2 -t $time  -P $num -f $type > $num.log

    	bandwidth=`tail -1 $num.log |awk '{print $(NF-1)}'`
    	if [ "$bandwidth" -gt "$ge_bandwidth" ];then 
        	echo "P=$num Pass." >> iperf.txt
    	else
		echo "P=$num Fail,bandwidth is ${bandwidth}M." >> iperf.txt
    	fi
    done
    pass=`cat iperf.txt |grep -w Pass|wc -l` 
    fail=`cat iperf.txt |grep -w Fail|awk '{print $1}'|tr '\n' '|'`
    if [ $pass -eq ${#thread[@]} ];then
    	writePass
    else
    	writeFail "${fail}Bandwidth did not meet the requirement."
    fi
    rm -f iperf.txt
}

function main()
{
    JIRA_ID="PV-456"
    Test_Item="Iperf transfer(GE port)"
    Designed_Requirement_ID="R.HNS.P001.A"

    iperf_transfer_test
}


main


