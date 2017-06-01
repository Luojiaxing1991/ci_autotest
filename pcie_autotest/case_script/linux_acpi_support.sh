#!/bin/bash

# run the linux acpi support feature by intel82599 
# IN :N/A
# OUT:N/A

function support_linux_acpi_test()
{
    Test_Case_Title="support_linux_acpi_test"
    Test_Case_ID="ST.FUNC.048"
    INTEL82599_NAME="82599ES"
    acpi_boot="acpi=force"
    info=`cat /proc/cmdline |grep "$acpi_boot"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of $INTEL82599_NAME $acpi_boot failure."
        return 1
    fi
    writePass
}

function main()
{
    JIRA_ID="PV-568"
    Test_Item="linux-acpisupport"
    Designed_Requirement_ID="R.PCIE.F088.A"

    support_linux_acpi_test
}

main


