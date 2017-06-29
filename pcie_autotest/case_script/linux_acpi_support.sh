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

function support_acpi_hip_driver_test()
{
    Test_Case_Title="support_acpi_hip_driver_test"
    Test_Case_ID="ST.FUNC.002"
    PCIE_DRIVER="ixgbe|mpt3sas|igb|hibmc-drm|nvme"
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
    JIRA_ID="PV-568"
    Test_Item="linux-acpi-support/ACPI-Hip-Driver"
    Designed_Requirement_ID="R.PCIE.F088.A"

    support_linux_acpi_test
    support_acpi_hip_driver_test
}

main
