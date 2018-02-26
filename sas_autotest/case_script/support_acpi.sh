#!/bin/bash



# check the system startup method.
# IN : N/A
# OUT: N/A
function check_acpi_start()
{
    Test_Case_Title="check_acpi_start"

    info=`cat /proc/cmdline | grep ${ACPI_KEY_INFO}`
    [ x"${info}" == x"" ] MESSAGE="FAIL\tThe current system is not acpi way to start." && return 1
    MESSAGE="PASS"
}

function main()
{
    # call the implementation of the automation use cases
    test_case_function_run
}

main

