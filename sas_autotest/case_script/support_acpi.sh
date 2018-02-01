#!/bin/bash



# check the system startup method.
# IN : N/A
# OUT: N/A
function check_acpi_start()
{
    Test_Case_Title="check_acpi_start"
    Test_Case_ID="ST.FUNC.202"

    info=`cat /proc/cmdline | grep ${ACPI_KEY_INFO}`
    [ x"${info}" == x"" ] weiteFail "The current system is not acpi way to start." && return 1

    writePass
}

function main()
{
    JIRA_ID="PV-1946"
    Test_Item="R.SAS.F018.A"
    Designed_Requirement_ID="support ACPI for probe and reset"

    # check the system startup method.
    check_acpi_start
}

main

