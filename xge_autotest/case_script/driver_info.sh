#!/bin/bash

# query driver info
# IN :N/A
# OUT:N/A
function driver_info_query()
{
    Test_Case_Title="The network port driver version information is correct"
    Test_Case_ID="ST_SGE_GET_DRVINFO_000"
	D05flag=$(ssh root@$BACK_IP ':> D05driverinfo.txt; ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up ; for i in eth0 eth1 eth2 eth3 ; do ethtool -i $i >> D05driverinfo.txt ; done; ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down ; for i in eth0 eth1 eth2 eth3; do ethtool -i $i >> D05driverinfo.txt ; done; drivervalue=`cat D05driverinfo.txt | grep -w "hns" | wc -l`; versionvalue=`cat D05driverinfo.txt | grep -w "2.0" | wc -l`; if [ $drivervalue -eq 8 -a $versionvalue -eq 8 ];then D05flag=1;fi; echo $D05flag ; rm -rf D05driverinfo.txt')
	:> D03driverinfo.txt
    ifconfig eth1 up; ifconfig eth2 up; ifconfig eth3 up;
	for i in eth0 eth1 eth2 eth3
	do
   	   ethtool -i $i >> D03driverinfo.txt;
    done
    ifconfig eth1 down; ifconfig eth2 down; ifconfig eth3 down;
	for i in eth0 eth1 eth2 eth3
	do
   	   ethtool -i $i >> D03driverinfo.txt;
    done
    drivervalue=`cat D03driverinfo.txt | grep -w "hns" | wc -l`
    versionvalue=`cat D03driverinfo.txt | grep -w "2.0" | wc -l`
    if [ $drivervalue -eq 8 -a $versionvalue -eq 8 ];then
      D03flag=1;
    fi

    if [ $D03flag -eq 1 -a $D05flag -eq 1 ];then
	     writePass
	else
         writeFail
	fi

}

function main()
{
    JIRA_ID="PV-1507"
    Test_Item="support to get driver informations"
    Designed_Requirement_ID="R.HNS.F028A"
	driver_info_query
}


main


