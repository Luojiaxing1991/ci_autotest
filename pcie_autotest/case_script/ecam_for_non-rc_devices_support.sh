#!/bin/bash


# run the PCIe ECAM support for non-RC devices feature by PCIe EP model
# IN :N/A
# OUT:N/A
function support_ecam_non-rc_devices_test()
{
    Test_Case_Title="support_ecam_non-rc_devices_test"
    Test_Case_ID="ST.FUNC.030"
    PCIE_DRIVER="ixgbe|mpt3sas|igb|hibmc-drm|nvme"

    ecam_access=`dmesg |grep "ECAM"`
    if [ x"$ecam_access" == x"" ]
    then
        writeFail "The AR requirement of PCIe ECAM support for non-RC devices by ECAM access mechanisms for the EP config space failure."
        return 1
    fi
    enmueration_ep=`lspci -k |grep -E "$PCIE_DRIVER" |awk -F ':' '{print $2}'`
    if [ x"$enmueration_ep" == x"" ]
    then
        writeFail "The AR requirement of PCIe ECAM support for non-RC devices by checking the PCIe cards'drivers and enmuerating EP failure."
        return 1
    fi
    writePass
}

function main()
{
    JIRA_ID="PV-326"
    Test_Item="ECAM-support-for-nonRC-devices"
    Designed_Requirement_ID="R.PCIE.F021.A"
 
    support_ecam_non-rc_devices_test
}

main
