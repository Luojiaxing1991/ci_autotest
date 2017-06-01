#!/bin/bash

# set rate link value
# IN : N/A
# OUT: N/A
function set_rate_link()
{
    for dir in `ls ${PHY_FILE_PATH}`
    do
        type=`cat ${PHY_FILE_PATH}/${dir}/device_type`
        if [ x"$type" == x"end device" ]
        then
            echo $MINIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/minimum_link
            echo $MAXIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/maximum_link
            [ $? -ne 0 ] && writeFail "Failed to set the maximum rate of \"$dir\" greater than the minimum rate." && return 1

            echo $MINIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/maximum_link 
            [ $? -ne 0 ] && writeFail "Failed to set the \"$dir\" maximum rate equal to the minimum rate." && return 1

            echo $MAXIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/minimum_link
            [ $? -eq 0 ] && writeFail "Failed to set the \"$dir\" maximum rate less than the minimum rate." && return 1
        fi
    done
    return 0
}

# Rate set up
# IN : N/A
# OUT: N/A
function rate_set_up()
{
    Test_Case_Title="rate_set_up"
    Test_Case_ID="ST.FUNC.004"

    set_rate_link
    [ $? -ne 0 ] && return 1

    writePass
}

# Loop rate set up
# IN : N/A
# OUT: N/A
function loop_rate_set_up()
{
    Test_Case_Title="loop_rate_set_up"
    Test_Case_ID="ST.FUNC.004"

    for num in ${LOOP_RATE_SET_UP_NUMBER}
    do
        set_rate_link
        [ $? -ne 0 ] && return 1        
    done
    writePass
}

function main()
{
    JIRA_ID="PV-100"
    Test_Item="Phy control through sysfs"
    Designed_Requirement_ID="R.SAS.F017.A"

    rate_set_up

    [ ${IS_LOOP_RATE_SET_UP} -eq 1 ] && loop_rate_set_up
}

main


