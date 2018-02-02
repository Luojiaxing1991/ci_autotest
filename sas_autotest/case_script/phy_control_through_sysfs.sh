#!/bin/bash

# set rate link value
# IN : N/A
# OUT: N/A
function set_rate_link()
{
    for dir in `ls ${PHY_FILE_PATH}`
    do
        type=`cat ${PHY_FILE_PATH}/${dir}/target_port_protocols`
        if [ x"$type" != x"none" ]
        then
            echo $MINIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/minimum_linkrate
            echo $MAXIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/maximum_linkrate
            [ $? -ne 0 ] && MESSAGE="FAIL\tFailed to set the maximum rate of \"${dir}\" greater than the minimum rate." && return 1

            echo $MINIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/maximum_linkrate
            [ $? -ne 0 ] && MESSAGE="FAIL\tFailed to set the \"${dir}\" maximum rate equal to the minimum rate." && return 1

            echo $MAXIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/minimum_linkrate
            [ $? -eq 0 ] && MESSAGE="FAIL\tFailed to set the \"${dir}\" maximum rate less than the minimum rate." && return 1
        fi
        sleep 5
    done
    return 0
}

# Rate set up
# IN : N/A
# OUT: N/A
function rate_set_up()
{
    Test_Case_Title="rate_set_up"

    set_rate_link
    [ $? -ne 0 ] && return 1

    MESSAGE="PASS"
}

# Loop rate set up
# IN : N/A
# OUT: N/A
function loop_rate_set_up()
{
    Test_Case_Title="loop_rate_set_up"

    for num in ${LOOP_RATE_SET_UP_NUMBER}
    do
        set_rate_link
        [ $? -ne 0 ] && MESSAGE="FAIL\tThe loop setting PHY rate value failed" && return 1
        sleep 2
    done
    MESSAGE="PASS"
}

function main()
{
    # call the implementation of the automation use cases
    test_case_function_run
}

main


