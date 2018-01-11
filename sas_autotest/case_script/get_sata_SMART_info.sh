#!/bin/bash

# Get the SMART information for the SATA disk
# IN : N/A
# OUT: N/A
function get_sata_SMART_info()
{
    Test_Case_Title="get_sata_SMART_info"
	Test_Case_ID="ST.FUNC.117"

	assert=0
	for disk_name in `fdisk -l | grep -o "/dev/[a-z]d[a-z]" | uniq`
	do
		device_info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/lsscsi -t -L | \
			              grep -A 10 '${disk_name}' | grep 'target_port_protocols'`
		info=`echo ${device_info} | awk -F '=' '{print $2}'`
		[ x"${info}" = x"ssp" ] && continue

        info=`${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/disktool -S s ${disk_name}`
		[ x"${info}" = x"" ] && writeFail "Failed to get ${disk_name} disk SMART information." && return 1

        assert=1
	done

	[ ${assert} -eq 0 ] && writeFail "There is no SATA disk in the system environment." && return 1

	writePass
}

function main()
{
    JIRA_ID="PV-1608"
	Test_Item="Support SMART"
	Designed_Requirement_ID="R.SAS.F015A"

	get_sata_SMART_info
}

main

