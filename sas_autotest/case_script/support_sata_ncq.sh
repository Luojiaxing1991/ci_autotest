#!/bin/bash


# SATA ncq keyword query.
# IN : N/A
# OUT: N/A
function ncq_query()
{
    Test_Case_Title="ncq_query"

    info=`dmesg | grep 'NCQ'`
    [ x"${info}" = x"" ] && MESSAGE="FAIL\tQuery keyword \"NCQ\" failed." && return 1

    MESSAGE="PASS"
}

function main()
{
    # call the implementation of the automation use cases
    test_case_function_run
}

main
