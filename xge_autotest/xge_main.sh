#!/bin/bash

HNS_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load common function
. ${HNS_TOP_DIR}/config/xge_test_config
. ${HNS_TOP_DIR}/config/xge_test_lib

# Load the public configuration library
. ${HNS_TOP_DIR}/../config/common_config
. ${HNS_TOP_DIR}/../config/common_lib


# Main operation function
# IN : N/A
# OUT: N/A

function main()
{
    echo "Begin to Run XGE Test"
    
    if [ x"${BACK_IP}" = x"192.168.3.229" ]
    then
	return 1
    fi

    local MaxRow=$(sed -n '$=' "${HNS_TOP_DIR}/${TEST_CASE_DB_FILE}")
    local RowNum=0
    while [ ${RowNum} -lt ${MaxRow} ]
    do
        let RowNum+=1
        local line=$(sed -n "${RowNum}p" "${HNS_TOP_DIR}/${TEST_CASE_DB_FILE}")
        exec_script=`echo "${line}" | awk -F '\t' '{print $6}'`
        TEST_CASE_FUNCTION_NAME=`echo "${line}" | awk -F '\t' '{print $7}'`
        TEST_CASE_FUNCTION_SWITCH=`echo "${line}" | awk -F '\t' '{print $8}'`
        TEST_CASE_TITLE=`echo "${line}" | awk -F '\t' '{print $3}'`

        echo "CaseInfo "${TEST_CASE_TITLE}" "$exec_script" "$TEST_CASE_FUNCTION_NAME" "$TEST_CASE_FUNCTION_SWITCH 

        if [ x"${exec_script}" == x"" ]
        then
            MESSAGE="unimplemented automated test cases."
	    echo ${MESSAGE}
        else
            if [ ! -f "${HNS_TOP_DIR}/case_script/${exec_script}" ]
            then
                MESSAGE="case_script/${exec_script} execution script does not exist, please check."
		echo ${MESSAGE}
            else
		if [ x"${TEST_CASE_FUNCTION_SWITCH}" == x"on" ]
		then 
			echo "Begin to run script: "${exec_script}
                        source ${HNS_TOP_DIR}/case_script/${exec_script}
		else
			echo "Skip the script: "${exec_script}
		fi
            fi
        fi
        echo -e "${line}${MESSAGE}" >> ${HNS_TOP_DIR}/${OUTPUT_TEST_DB_FILE}
        MESSAGE=""
    done
    echo "Finish to run XGE test!"
}

#Output log file header
writeLogHeader

#Xge test is only excute in 159 dash board
#Find the local MAC
tmpMAC=`ifconfig eth0 | grep "HWaddr" | awk '{print $NF}'`
if [ x"${tmpMAC}" = x"${BOARD_159_MAC_ADDR}" ]
then
	echo "Xge test can be excute in this board!"
else
	echo "Xge test can not be excute in this board,exit!"
	exit 0
fi

#ifconfig IP
initLocalIP 
LOCAL_IP=${COMMON_LOCAL_IP}
echo ${LOCAL_IP}

#init_client_ip

getIPofClientServer ${DHCP_SERVER_MAC_ADDR} ${CLIENT_SERVER_MAC_ADDR} ${DHCP_SERVER_USER} ${DHCP_SERVER_PASS}

if [ x"${COMMON_CLIENT_IP}" = x"" ] || [ x"${COMMON_CLIENT_IP}" = x"0.0.0.0" ]
then
	echo "No found client IP,try ping default DHCP ip to update arp list!"
        ping ${COMMON_DEFAULT_DHCP_IP} -c 5
        getIPofClientServer ${DHCP_SERVER_MAC_ADDR} ${CLIENT_SERVER_MAC_ADDR} ${DHCP_SERVER_USER} ${DHCP_SERVER_PASS}
        if [ x"${COMMON_CLIENT_IP}" = x"" ]
        then
		echo "Can not find the client IP, exit hns test!"
                exit 0
        fi
fi

BACK_IP=${COMMON_CLIENT_IP}
echo "The client ip is "${BACK_IP}

#set passwd
setTrustRelation

#ifconfig net export
init_net_export

#performance init
perf_init

main

# clean exit so lava-test can trust the results
exit 0

