#!/bin/bash

#run teh PCIe 1.0 and 2.0 backward compatibility on No.204 D05 board
# IN :N/A
# OUT:N/A
function support_pcie_1.0_2.0_backward_compatibility_vga_test()
{
    Test_Case_Title="support_pcie_1.0_2.0_backward_compatibility_vga_test"
    Test_Case_ID="ST.FUNC.030"
    VGA_NAME="VGA compatible controller: Device 19e5:1711"
    VGA_DRIVER="hibmc-drm"
    RC_Base_Addr_VGA_D05="0x8a00b0080"
    VGA_Mem_Addr=`devmem "$RC_Base_Addr_VGA_D05"`
    X1_gen1=`echo "$VGA_Mem_Addr" |cut -c5-6`
    if [ x"$X1_gen1" == x"" ]
    then
        writeFail "The AR requirement of $VGA_NAME PCIe gen1 build link failure."
        return 1
    fi

    enumerate=`lspci -k |grep "$VGA_NAME"`
    if [ x"$enumerate" == x"" ]
    then
        writeFail "The AR requirtment of $VGA_NAME PCIe gen1 enumerate failure."
        return 1
    fi

    load_driver=`lspci -k |grep "$VGA_DRIVER"`
    if [ x"$load_driver" == x"" ]
    then
        writeFail "The AR requirtment of $VGA_NAME PCIe gen1 kernel load driver failure."
        return 1
    fi

    writePass
}

function main()
{
    JIRA_ID="PV-324"
    Ttttest_Item="pcie-1.0-2.0-backward-compatibility-vga-test"
    Designed_Requirement_ID="R.PCIE.F019A"

    support_pcie_1.0_2.0_backward_compatibility_vga_test
}

main

