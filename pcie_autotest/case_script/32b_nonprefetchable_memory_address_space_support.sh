#!/bin/bash

# run the 32b non-prefetchable memory address space support feature by VGA
# IN :N/A
# OUT:N/A
function support_32nonprefetchable_memory_address_space_vga_test()
{
    Test_Case_Title="support_32nonprefetchable_memory_address_space_vga_test"
    Test_Case_ID="ST.FUNC.031/ST.FUNC.032"
    vga_device="19e5:1711"
    b_nonprefetchable="32-bit, non-prefetchable"
    info=`lspci -vvv |grep "${vga_device}" -A 8 |grep "${b_nonprefetchable}"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of VGA $b_nonprefetchable failure."
        return 1
    fi

    writePass
}

# run the 32b non-prefetchable memory address space support feature by I350 network card
# IN :N/A
# OUT:N/A
function support_32nonprefetchable_memory_address_space_i350_test()
{
    Test_Case_Title="support_nonprefetchable_memory_address_space_i350_test"
    Test_Case_ID="ST.FUNC.033/ST.FUNC.034"
    i350_device="19e5:d113"
    b_nonprefetchable="32-bit, non-prefetchable"
    info=`lspci -vvv |grep "$i350_device" -A 8 |grep "$b_nonprefetchable"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of i350 $b_nonprefetchable failure."
        return 1
    fi

    writePass
}

function main()
{
    JIRA_ID="PV-368"
    Test_Item="32b-non-prefetchable-memory-address-space-support"
    Designed_Requirement_ID="R.PCIE.F049.A"

    support_32nonprefetchable_memory_address_space_vga_test
    support_32nonprefetchable_memory_address_space_i350_test
}

main

