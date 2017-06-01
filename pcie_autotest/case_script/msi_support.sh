!#/bin/bash

# run the MSI interrupt feature by Intel 82599 network card
# IN :N/A
# OUT:N/A
function support_msi_interrupt_82599_test()
{
    Test_Case_Title="support_msi_interrupt_82599_test"
    Test_Case_ID="ST.FUNC.013/ST.FUNC.014"
    INTEL82599_NAME="82599ES"
    MSI_ENABLE="MSI: Enable+"
    lspci -vvvv >lspci-vvvv.txt
    info=`grep -A 17 "$INTEL82599_NAME" lspci-vvvv.txt | grep "$MSI_ENABLE"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of $INTEL82599_NAME $MSI_ENABLE failure."
        return 1
    fi
    writePass
}


function main()
{
    JIRA_ID="PV-316"
    Test_Item="msi-support"
    Designed_Requirement_ID="R.PCIE.F005.A"

    support_msi_interrupt_82599_test
}

main

