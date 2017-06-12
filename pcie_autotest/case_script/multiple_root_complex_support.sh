#!/bin/bash


# run the Multiple Root Complex feature by PCIe cards, verify all PCIe ports on D05 boards function
# IN :N/A
# OUT:N/A
function support_multiple_root_complex_test()
{
    Test_Case_Title="support_multiple_root_complex_test"
    Test_Case_ID="ST.FUNC.000"
    BOOT_MODE="acpi=force"
    PCIE_DRIVER="ixgbe|mpt3sas|igb|hibmc-drm|nvme"

    cmdline_info=`cat /proc/cmdline |grep "$BOOT_MODE"`
    if [ x"$cmdline_info" == x"" ]
    then
        writeFail "The AR requirement of the Multiple Root Complex support by $BOOT_MODE in the command line failure."
        return 1
    fi
    driver_info=`lspci -k |grep -E "$PCIE_DRIVER" |awk -F ':' '{print $2}'`
    if [ x"$driver_info" == x"" ]
    then
        writeFail "The AR requirement of the Multiple Root Complex support by checking the PCIe cards'drivers failure."
        return 1
    fi
    writePass
}

function main()
{
    JIRA_ID="PV-315"
    Test_Item="Multiple-Root-Complex-support"
    Designed_Requirement_ID="R.PCIE.F001.A"

    support_multiple_root_complex_test
}

main
