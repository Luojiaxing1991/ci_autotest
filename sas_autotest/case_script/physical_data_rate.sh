#!/bin/bash

# Disk negotiated link rate query
# IN : N/A
# OUT: N/A
function disk_negotiated_link_rate_query()
{
    Test_Case_Title="disk_negotiated_link_rate_query"
    Test_Case_ID="ST.FUNC.005/ST.FUNC.006"

    for dir in `ls ${PHY_FILE_PATH}`
    do
        type=`cat ${PHY_FILE_PATH}/${dir}/target_port_protocols`
        [ x"${type}" = x"none" ] && continue

        rate_value=`cat ${PHY_FILE_PATH}/${dir}/negotiated_linkrate | awk -F '.' '{print $1}'`
        BRate=1
        for rate in `echo $DISK_NEGOTIATED_LINKRATE_VALUE | sed 's/|/ /g'`
        do
            if [ $(echo "${rate_value} ${rate}"|awk '{if($1=$2){print 0}else{print 1}}') -eq 0 ]
            then
                BRate=0
                break
            fi
        done

        if [ $BRate -eq 1 ]
        then
            writeFail "\"${dir}\" negotiated link rate query ERROR."
            return 1
        fi
    done
    writePass
}

function main()
{
    JIRA_ID="PV-1597/PV-1604"
    Test_Item="physical data rate"
    Designed_Requirement_ID="R.SAS.F006/R.SAS.F007"

    disk_negotiated_link_rate_query
}

main

