#!/bin/bash

# run the 64b prefetchable memory address space support feature by p3600
# IN :N/A
# OUT:N/A

function support_64prefetchable_memory_address_space_p3600_test()
{
    Test_Case_Title="support_32prefetchable_memory_address_space_p3600_test"
    Test_Case_ID="ST.FUNC.039/ST.FUNC.040"
    p3600_bar_addr="000d:31:00.0"
    b64_prefetchable="0x79040000000-0x79040003fff 64bit"
    info=`dmesg |grep pci |grep "$p3600_bar_addr" |grep "$b64_prefetchable"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of p3600 SSD $b64_prefetchable failure."
        return 1
    fi
    writePass
}



# run the 64b prefetchable memory address space support feature by intel82599
# IN :N/A
# OUT:N/A

function support_64prefetchable_memory_address_space_intel82599_test()
{
    Test_Case_Title="support_64prefetchable_memory_address_space_intel82599_test"
    Test_Case_ID="ST.FUNC.041/ST.FUNC.042"
    intel82599_bar_addr="0002:81:00.0"
    b64_prefetchable="0xa9000000-0xa93fffff 64bit pref"
    info=`dmesg |grep pci |grep "$intel82599_bar_addr" |grep "$b64_prefetchable"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of intel82599 $b64_prefetchable failure."
        return 1
    fi
    writePass
}


function main()
{
    JIRA_ID="PV-370"
    Test_Item="64b-prefetchable-memory-address-space-support"
    Designed_Requirement_ID="R.PCIE.F052A"

    support_64prefetchable_memory_address_space_p3600_test
    support_64prefetchable_memory_address_space_intel82599_test
}

main

