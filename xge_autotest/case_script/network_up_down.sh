#!/bin/bash
#!/usr/bin/expect

# set checksum offload
# IN :N/A
# OUT:N/A

function network_up_down()
{
    :> ping_$1.log	
    if [ $1 == "eth1" ];then
        Local_IP="192.168.10.10"
        Remote_IP="192.168.10.20"
    elif [ $1 == "eth2" ];then
        Local_IP="192.168.20.10"
        Remote_IP="192.168.20.20"
    else
	Local_IP="192.168.30.10"
	Remote_IP="192.168.30.20"
    fi
    ifconfig $1 $Local_IP 
    ssh root@$BACK_IP "ifconfig $1 $Remote_IP"
    sleep 5

    for ((i=1;i<$2;i++))
    do
        echo "############### down network #############"\r >> ping_$1.log
        ifconfig $1 down
	ssh root@$BACK_IP "ifconfig $1 down"
        ping $Remote_IP -c 5 >> ping_$1.log &
        sleep 10
        echo "############### down network #############"\r >> ping_$1.log
        
	echo "############### up network ###############" >> ping_$1.log
        ifconfig $1 up
	ssh root@$BACK_IP "ifconfig $1 up"
        ping $Remote_IP -c 5 >> ping_$1.log &
        sleep 5
        echo "############### up network #############"\r >> ping_$1.log
    done 
}

function main()
{
    JIRA_ID="PV-434"
    Test_Item="Enable and Disable of Interface"
    Designed_Requirement_ID="R.NS.F001A"
    network_up_down
}

main
