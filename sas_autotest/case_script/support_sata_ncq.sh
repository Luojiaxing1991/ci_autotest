#!/bin/bash


# SATA ncq keyword query.
# IN : N/A
# OUT: N/A
function ncq_query()
{
    Test_Case_Title="ncq_query"
    Test_Case_ID="ST.FUNC.191"

    info=`dmesg | grep 'NCQ'`
    [ x"${info}" = x"" ] && writeFail "Query keyword \"NCQ\" failed." && return 1

    writePass
}

function main()
{
    JIRA_ID="PV-1607"
    Test_Item="Support SATA NCQ"
    Designed_Requirement_ID="R.SAS.F012.A"

    ncq_query
}

main

