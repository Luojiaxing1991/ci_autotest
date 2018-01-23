#!/bin/bash

#Verify rocee is platform device
#IN	:N/A
#OUT:N/A
function platformdev ()
{
	if [ -e /sys/devices/platform/HISI00D1\:00 ]
	then
		writePass "The RoCEE is plathform device named HISI00D1:00 !"
	else
		writeFail "The RoCEE does not exist!"
	fi

	return 0
}

function main()
{
	JIRA_ID="PV-366"
	Designed_Requirement_ID="R.ROCE.N006.B"
	Test_Case_ID="ST-ROCE-85"
	Test_Item="Verify rocee is Linux platform device in Hi161x"
	Test_Case_Title=""

	platformdev
}
main
