#!/bin/bash

# run the MSI-x interrupt feature by Intel 82599 network card
# IN :N/A
# OUT:N/A
function support_msix_interrupt_82599_test()
{
    Test_Case_Title="support_msix_interrupt_82599_test"
    Test_Case_ID="ST.FUNC.015/ST.FUNC.016"
    INTEL82599_NAME="82599ES"
    MSIX_ENABLE="MSI-X: Enable+"
    lspci -vvvv >lspci-vvvv.txt
    info=`grep -A 17 "$INTEL82599_NAME" lspci-vvvv.txt | grep "$MSIX_ENABLE"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of $INTEL82599_NAME $MSIX_ENABLE failure."
        return 1
    fi
    writePass
}


# run the MSI-x interrupt feature by P3600 SSD card
# IN :N/A
# OUT:N/A
function support_msix_interrupt_p3600_test()
{
    Test_Case_Title="support_msix_interrupt_p3600_test"
    Test_Case_ID="ST.FUNC.017/ST.FUNC.018"
    P3600_NAME="Intel Corporation Device 0953"
    MSIX_ENABLE="MSI-X: Enable+"
    lspci -vvvv >lspci-vvvv.txt
    info=`grep -A 17 "$P3600_NAME" lspci-vvvv.txt | grep "$MSIX_ENABLE"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of $P3600_NAME $MSIX_ENABLE failure."
        return 1
    fi
    writePass
}

# run the MSI-x interrupt feature by I350 network card
# IN :N/A
# OUT:N/A
function support_msix_interrupt_i350_test()
{
    Test_Case_Title="support_msix_interrupt_i350_test"
    Test_Case_ID="ST.FUNC.019/ST.FUNC.020"
    I350_NAME="I350"
    MSIX_ENABLE="MSI-X: Enable+"
    lspci -vvvv >lspci-vvvv.txt
    info=`grep -A 17 "$I350_NAME" lspci-vvvv.txt | grep "$MSIX_ENABLE"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of $I350_NAME $MSIX_ENABLE failure."
        return 1
    fi
    writePass
}


function main()
{
    JIRA_ID="PV-317"
    Test_Item="msix-support"
    Designed_Requirement_ID="R.PCIE.F006.A"

    support_msix_interrupt_82599_test
    support_msix_interrupt_p3600_test
    support_msix_interrupt_i350_test
}

main

exit 0

