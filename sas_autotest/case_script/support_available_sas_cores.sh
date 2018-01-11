#!/bin/bash


# fio tool to read and write disk.
# IN  : N/A
# OUT : N/A
function FIO_IO_read_write()
{
    Test_Case_Title="repeat_IO_read_write"
    Test_Case_ID="ST.FUNC.018/ST.FUNC.019/ST.FUNC.024/ST.FUNC.025/ST.FUNC.028/ST.FUNC.029/ST.FUNC.035/ST.FUNC.036"

    # Generate FIO configuration file
    fio_config

    IO_read_write
    [ $? -eq 1 ] && writeFail "FIO tool read and write disk failure." && return 1

    writePass
}

# fio tools mixed io read and write
# IN  : N/A
# OUT : N/A
function FIO_IO_RAIO_randrw()
{
    Test_Case_Title="FIO_IO_RAIO_randrw"
    Test_Case_ID="ST.FUNC.056"

    # Generate FIO configuration file
    fio_config

    sed -i '/rw/a\rwmixread=' fio.conf
    sed -i '/rwmixread/a\bsrange=' fio.conf
    sed -i "{s/^bsrange=.*/bsrange=${BSRANGE}/g;}" fio.conf
    sed -i "{s/^rw=.*/rw=randrw/g;}" fio.conf

    for ratio in "${IO_RATIO[@]}"
    do
        sed -i "{s/^rwmixread=.*/rwmixread=${ratio}/g;}" fio.conf
        fio fio.conf
        [ $? -ne 0 ] && writeFail "fio tool ${ratio} raio mixed io read and write failed." && return 1
    done

    writePass
}

# fio tools only io read-only write.
# IN  : N/A
# OUT : N/A
function FIO_IO_RAIO_read_write()
{
    Test_Case_Title="FIO_IO_RAIO_read_write"
    Test_Case_ID="ST.FUNC.042/ST.FUNC.043/ST.FUNC.044"

    # Generate FIO configuration file
    fio_config

    sed -i '/rwmixread/a\bsrange=' fio.conf
    sed -i '/bsrange/a\bssplit=' fio.conf
    sed -i "{s/^bsrange=.*/bsrange=${BSRANGE}/g;}" fio.conf
    sed -i "{s/^bssplit=.*/bssplit=${BSSPLIT}/g;}" fio.conf

    for rw in read write
    do
        sed -i "{s/^rw=.*/rw=i${rw}/g;}" fio.conf
        fio fio.conf
        [ $? -ne 0 ] && writeFail "fio tool ${rw} io read and write failed." && return 1
    done

    writePass
}

function main()
{
    JIRA_ID="PV-1724/PV-1725"
    Test_Item="SAS 2.0/SAS 3.0"
    Designed_Requirement_ID="R.SAS.N003A/R.SAS.F005.A"


    FIO_IO_read_write

    FIO_IO_RAIO_randrw

    FIO_IO_RAIO_read_write
}

main


