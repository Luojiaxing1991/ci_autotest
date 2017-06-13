#!/bin/bash

# run the PCIe: Hisilicon PCIe re-use with the same Image
# IN :N/A
# OUT:N/A
function support_hisilicon_pcie_re-use_image_test()
{
    Test_Case_Title="support_hisilicon_pcie_re-use_image_test"
    Test_Case_ID="ST.FUNC.010/ST.FUNC.011"
    main_version=`uname -r`
    back_version=`ssh root@$BACK_IP 'uname -r'`
    if [ x"${main_version}" != x"${back_version}" ]
    then
        writeFail "The AR requirement of $Hisilicon PCIe re-use Image about 1612&1616 chip failure."
        return 1
    fi
    writePass
}

function main()
{
    JIRA_ID="PV-1425"
    Test_Item="PCIe_hisilicon_PCIe_re-use_Image_1612&1616"
    Designed_Requirement_ID="R.PCIE.F086.A"

    support_hisilicon_pcie_re-use_image_test
}

main


