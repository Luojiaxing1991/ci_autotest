#!/bin/bash

# run the 32b prefetchable memory address space support feature by intel82599
# IN :N/A
# OUT:N/A

function support_32prefetchable_memory_address_space_intel82599_test()
{
    Test_Case_Title="support_32prefetchable_memory_address_space_intel82599_test"
    Test_Case_ID="ST.FUNC.035/ST.FUNC.036"
    intel82599_bar_addr="0002:81:00.0"
    b_prefetchable="0xffc00000-0xffffffff pref"
    info=`dmesg |grep pci |grep "$intel82599_bar_addr" |grep "$b_prefetchable"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of intel82599 $b_prefetchable failure."
        return 1
    fi
    writePass
}

# run the 32b prefetchable memory address space support feature by p3600
# IN :N/A
# OUT:N/A

function support_32prefetchable_memory_address_space_p3600_test()
{
    Test_Case_Title="support_32prefetchable_memory_address_space_p3600_test"
    Test_Case_ID="ST.FUNC.037/ST.FUNC.038"
    p3600_bar_addr="000d:31:00.0"
    b_prefetchable="0x79040000000-0x7904000ffff pref"
    info=`dmesg |grep pci |grep "$p3600_bar_addr" |grep "$b_prefetchable"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of p3600 SSD $b_prefetchable failure."
        return 1
    fi

    writePass
}

function main()
{
    JIRA_ID="PV-369"
    Test_Item="32b-prefetchable-memory-address-space-support"
    Designed_Requirement_ID="R.PCIE.F050A"

    support_32prefetchable_memory_address_space_intel82599_test
    support_32prefetchable_memory_address_space_p3600_test
}

main


