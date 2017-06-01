#!/bin/bash



# FIO read and write disk
# IN : N/A
# OUT: N/A
function IO_read_write()
{
    for bs in "${FIO_BS[@]}"
    do
        sed -i "{s/^rw=.*/rw=$bs/g;}" fio.conf
        for rw in "${FIO_RW[@]}"
        do
            sed -i "{s/^rw=.*/rw=$rw/g;}" fio.conf
            fio fio.conf
            if [ $? -ne 0 ]
            then
                writeFail "FIO tool in \"${bs}\" disk operation, error."
                return 1
            fi
        done
    done
    return 0
}

# Long time read / write disk.
# IN : N/A
# OUT: N/A
function loog_time_IO_read_write()
{
    Test_Case_Title="loog_time_IO_read_write"
    Test_Case_ID="ST.FUNC.055/ST.FUNC.057/ST.FUNC.058"
  
    sed -i "{s/^runtime=.*/runtime=$FIO_LONG_RUN_TIME/g;}" fio.conf
    IO_read_write
    [ $? -eq 1 ] && writeFail "FIO tool long read and write disk failure." && return 1
    writePass
}

# Repeat read / write disk
# IN : N/A
# OUT: N/A
function repeat_IO_read_write()
{
    Test_Case_Title="repeat_IO_read_write"
    Test_Case_ID="ST.FUNC.056"

    for num in `seq $REPEAT_RW_NUMBER`
    do
        IO_read_write
        [ $? -eq 1 ] && writeFail "FIO tool repeatedly read and write disk failure." && return 1
    done
    writePass
}

function main()
{
    JIRA_ID="PV-63"
    Test_Item="Support Max Cores"
    Designed_Requirement_ID="R.SAS.F005.A"

    # Generate FIO configuration file
    fio_config

    repeat_IO_read_write
    loog_time_IO_read_write
}

main


