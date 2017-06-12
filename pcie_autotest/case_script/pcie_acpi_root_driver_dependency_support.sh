#!/bin/bash


# run the PCIe ACPI Root Driver dependency feature by PCIe cards & ACPI Hip05,Hip06,Hip07 Driver on 1616 boards function
# IN :N/A
# OUT:N/A
function support_pcie_acpi_root_driver_dependency_test()
{
    Test_Case_Title="support_pcie_acpi_root_driver_dependency_test"
    Test_Case_ID="ST.FUNC.006"
    BOOT_MODE="acpi=force"
    PCIE_DRIVER="ixgbe|mpt3sas|igb|hibmc-drm|nvme"
    
    cmdline_info=`cat /proc/cmdline |grep "$BOOT_MODE"`
    if [ x"$cmdline_info" == x"" ]
    then
        writeFail "The AR requirement of PCIe ACPI Root Driver dependency by $BOOT_MODE in the command line failure." 
        return 1
    fi
    driver_info=`lspci -k |grep -E "$PCIE_DRIVER" |awk -F ':' '{print $2}'`
    if [ x"$driver_info" == x"" ]
    then
        writeFail "The AR requirement of PCIe ACPI Root Driver dependency by checking the PCIe cards'drivers failure."
        return 1
    fi
    writePass
}

function main()
{
    JIRA_ID="PV-1432/PV-568"
    Test_Item="PCIe-ACPI-Root-Driver-dependency"
    Designed_Requirement_ID="R.PCIE.F104.A/R.PCIE.F088.A"

    support_pcie_acpi_root_driver_dependency_test
}

main
