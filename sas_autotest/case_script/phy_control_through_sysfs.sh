#!/bin/bash

#recover disk linkrate file value
#IN : $1 org  minimum linkrate
#     $2 org  maximum linkrate
#     $3 dir of disk config
function recover_linkrate()
{
    echo "Begin to recove the origin value of max and min rate"

    echo "Para is "$1" "$2" "$3

    echo $1 > ${PHY_FILE_PATH}/$3/minimum_linkrate
    echo $2 > ${PHY_FILE_PATH}/$3/maximum_linkrate

    echo "The "$3" linkrate is recover as flow:"
    cat ${PHY_FILE_PATH}/${dir}/minimum_linkrate
    cat ${PHY_FILE_PATH}/${dir}/maximum_linkrate

    return 0
}

# set rate link value
# IN : N/A
# OUT: N/A
function set_rate_link()
{
    for dir in `ls ${PHY_FILE_PATH}`
    do
        type=`cat ${PHY_FILE_PATH}/${dir}/target_port_protocols`
	echo "Begin to check sas type in "${dir}
        if [ x"$type" != x"none" ]
        then
            echo "Begin to set rate in "${dir0}

            #this function will destroy the setting value of disk speed
            #so may be we should save the value first,then recove it after test
            tmp_min=`cat ${PHY_FILE_PATH}/${dir}/minimum_linkrate | awk '{printf $0}'`
            echo "origin min rate value is "$tmp_min
            tmp_max=`cat ${PHY_FILE_PATH}/${dir}/maximum_linkrate | awk '{printf $0}'`
            echo "origin max rate value is"$tmp_max

            echo $MINIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/minimum_linkrate
            echo $MAXIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/maximum_linkrate
            [ $? -ne 0 ] && MESSAGE="FAIL\tFailed to set the maximum rate of \"${dir}\" greater than the minimum rate." && recover_linkrate "${tmp_min}" "${tmp_max}" "${dir}" && return 1

            echo $MINIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/maximum_linkrate
            [ $? -ne 0 ] && MESSAGE="FAIL\tFailed to set the \"${dir}\" maximum rate equal to the minimum rate." && recover_linkrate "${tmp_min}" "${tmp_max}" "${dir}" && return 1

            echo $MAXIMUM_LINK_VALUE > ${PHY_FILE_PATH}/${dir}/minimum_linkrate
            [ $? -eq 0 ] && MESSAGE="FAIL\tFailed to set the \"${dir}\" maximum rate less than the minimum rate." && recover_linkrate "${tmp_min}" "${tmp_max}" "${dir}" && return 1

            recover_linkrate "${tmp_min}" "${tmp_max}" "${dir}"
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
    echo "Begin to run loop_rate_set_up with "$num" cycle."
    for num in ${LOOP_RATE_SET_UP_NUMBER}
    do
	echo "Start the "$num" cycle to set rate!"
        set_rate_link
        [ $? -ne 0 ] && MESSAGE="FAIL\tThe loop setting PHY rate value failed" && return 1
        sleep 2
    done
    MESSAGE="PASS"
}

function main()
{
    #Judge the current environment, directly connected environment or expander environment.
    judgment_network_env
    [ $? -eq 0 ] && echo "the current environment expander network, do not execute test cases." && return 0

    # call the implementation of the automation use cases
    test_case_function_run
}

main


