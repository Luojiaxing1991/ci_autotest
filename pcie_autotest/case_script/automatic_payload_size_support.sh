#!t 1bin/bash

# run the automatic payload size support feature by i350
# IN :N/A
# OUT:N/A

function support_automatic_payload_size_i350_test()
{
    Test_Case_Title="support_automatic_payload_size_i350_test"
    Test_Case_ID="ST.FUNC.052"
    i350_bar_addr="0005:01:00.0"
    automatic_payload_size_i350="Max Payload Size set to  512/ 512 (was  128), Max Read Rq  512"
    info=`dmesg |grep "$i350_bar_addr" |grep "$automatic_payload_size_i350"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of i350 $automatic_payload_size_i350 failure."
        return 1
    fi
    writePass
}


function support_automatic_payload_size_intel82599_test()
{
    Test_Case_Title="support_automatic_payload_size_i350_test"
    Test_Case_ID="ST.FUNC.053"
    intel82599_bar_addr="0002:81:00.0"
    automatic_payload_size_intel82599="Max Payload Size set to  512/ 512 (was  128), Max Read Rq  512"
    info=`dmesg |grep "$intel82599_bar_addr" |grep "$automatic_payload_size_intel82599"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of intel82599 $automatic_payload_size_intel82599 failure."
        return 1
    fi
    writePass
}

function support_automatic_payload_size_p3600_test()
{
    Test_Case_Title="support_automatic_payload_size_p3600_test"
    Test_Case_ID="ST.FUNC.054"
    i350_bar_addr="000d:31:00.0"
    automatic_payload_size_p3600="Max Payload Size set to  256/ 256 (was  128), Max Read Rq  256"
    info=`dmesg |grep "$p3600_bar_addr" |grep "$automatic_payload_size_p3600"`
    if [ x"$info" == x"" ]
    then
        writeFail "The AR requirement of p3600 $automatic_payload_size_p3600 failure."
        return 1
    fi
    writePass
}

function main()
{
    JIRA_ID="PV-1402"
    Test_Item="automatic-payload-size-support"
    Designed_Requirement_ID="R.PCIE.F025A"

    support_automatic_payload_size_i350_test
    support_automatic_payload_size_intel82599_test
    support_automatic_payload_size_p3600_test
}

main

