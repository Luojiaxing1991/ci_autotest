#!/bin/bash


# SATA keyword query
# IN : N/A
# OUT: N/A
function ATA_query()
{
	Test_Case_Title=""
	Test_Case_ID="ST.FUNC.105"

	info=`dmesg | grep 'NCQ'` 
    [ x"${info}" = x"" ] && writeFail "Query keyword \"ATA\" failed." && return 1

	writePass
}

function main()
{
    JIRA_ID="PV-1721"
	Test_Item="Support SATA NCQ"
	Designed_Requirement_ID="R.SAS.F012.A"

    ATA_query
}

main

