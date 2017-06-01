#!/bin/bash



# Disk operation, Reset the hard_reset file status.
# IN : N/A
# OUT: N/A
function IO_operation_hard()
{
    Test_Case_Title="IO_operation_hard"
    Test_Case_ID="ST.FUNC.062"

    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ./${COMMON_TOOL_PATH}/fio fio.conf &
    change_sas_phy_file 1 "hard_reset"

    sleep ${FIO_RESET_TIME}
    count=`ps -ef | grep fio | grep -v grep | grep -v vfio-irqfd-clea | wc -l`
    [ $count -ne 0 ] && writeFail "Disk operation, hard_reset failed." && return 1
    
    writePass

}

# Disk operation, Multiple reset the hard_reset file status.
# IN : N/A
# OUT: N/A
function IO_operation_multiple_hard()
{
   Test_Case_Title="IO_operation_multiple_hard"
   Test_Case_ID="ST.FUNC.062"
 
   sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
   ./${COMMON_TOOL_PATH}/fio fio.conf &

   for i in `seq ${RESET_COUNT}`
   do
       change_sas_phy_file 1 "hard_reset"
       sleep 2
   done

   sleep ${FIO_RESET_TIME}
   count=`ps -ef | grep fio | grep -v grep | grep -v vfio-irqfd-clea | wc -l`
   [ $count -ne 0 ] && writeFail "Disk operation, multiple hard_reset failed." && return 1

   writePass
}

# Disk operation, Reset the link_reset file status.
# IN : N/A
# OUT: N/A
function IO_operation_link()
{
    Test_Case_Title="IO_operation_link"
    Test_Case_ID=""

    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ./${COMMON_TOOL_PATH}/fio fio.conf &

    change_sas_phy_file 1 "link_reset"
    
    sleep ${FIO_RESET_TIME}
    count=`ps -ef | grep fio | grep -v grep | grep -v vfio-irqfd-clea | wc -l`
    [ $count -ne 0 ] && writeFail "Disk operation, link_reset failed." && return 1

    writePass
}

# Disk operation, Multiple reset the hard_reset file status.
# IN : N/A
# OUT: N/A
function IO_operation_multiple_link()
{
    Test_Case_Title="IO_operation_multiple_link"
    Test_Case_ID=""

    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ./${COMMON_TOOL_PATH}/fio fio.conf &

    for i in `seq ${RESET_COUNT}`
    do
        change_sas_phy_file 1 "link_reset"
        sleep 2
    done

    sleep ${FIO_RESET_TIME}
    count=`ps -ef | grep fio | grep -v grep | grep -v vfio-irqfd-clea | wc -l`
    [ $count -ne 0 ] && writeFail "Disk operation, multiple link_reset failed." && return 1

    writePass
}

# Disk operation, Reset the enable file status.
# IN : N/A
# OUT: N/A
function IO_operation_enable()
{
    Test_Case_Title="IO_operation_enable"
    Test_Case_ID=""

    sed -i "{s/^runtime=.*/runtime=${FIO_RESET_TIME}/g;}" fio.conf
    ./${COMMON_TOOL_PATH}/fio fio.conf &

    change_sas_phy_file 0 "enable"

    sleep ${FIO_RESET_TIME}
    count=`ps -ef | grep fio | grep -v grep | grep -v vfio-irqfd-clea | wc -l`
    [ $count -ne 0 ] && writeFail "Disk operation, enable failed." && return 1

    change_sas_phy_file 1 "enable"

    writePass
}

function main()
{
    JIRA_ID="PV-72"
    Test_Item="R.SAS.F008.A"
    Designed_Requirement_ID="Support SAS Narrow and Wide Ports"

    fio_config
    IO_operation_hard
    IO_operation_multiple_hard
    IO_operation_link
    IO_operation_multiple_link
    IO_operation_enable
}

main


