#!/bin/bash
# rx functionality
# IN :N/A
# OUT:N/A
function rx()
{
   Test_Case_Title="GE port ping the other ge port"
   Test_Case_ID="ST_GE_TX_RX_000"
   ifconfig eth1 up
   ifconfig eth1 192.168.100.212
   get_rx_packet()
   {
    rx_packet=$(ifconfig eth1 | grep -Po "(?<=RX packets:)([0-9]*)")
    echo $rx_packet
   }
   get_rx_byte()
   {
    rx_byte=$(ifconfig eth1 | grep -Po "(?<=RX bytes:)([0-9]*)")
    echo $rx_byte
   }
   rx_packet_init=$(get_rx_packet)
   rx_byte_init=$(get_rx_byte)
   ssh root@$BACK_IP 'ifconfig eth1 up; ifconfig eth1 192.168.100.200; ping 192.168.100.212 -c 3'
   rx_packet_after=$(get_rx_packet)
   rx_byte_after=$(get_rx_byte)
   # 4 means rx packets from the other board which value is equal to 3+1
   rx_packet=`expr $rx_packet_after - $rx_packet_init - 4`
   # 354 means rx bytes from the other board which value is equal to 98+98+98+60
   rx_byte=`expr $rx_byte_after - $rx_byte_init - 354`
   if [ $rx_packet -eq 0 -a $rx_byte -eq 0 ];then
     writePass
   else
     writeFail
   fi

}

function main()
{
    JIRA_ID="PV-435"
    Test_Item="basic function of send and receive packets"
    Designed_Requirement_ID="R.HNS.F002A"
    rx
}


main


