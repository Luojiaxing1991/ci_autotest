#!/bin/bash


# fio tool to read and write disk.
# IN  : N/A
# OUT : N/A
function FIO_IO_read_write()
{
    Test_Case_Title="FIO_IO_read_write"

    # Generate FIO configuration file
    fio_config
    echo "Begin to run FIO_IO_RW"
    IO_read_write
    [ $? -eq 1 ] && MESSAGE="FAIL\tFIO tool read and write disk failure." && echo "Fail fio tool rw" & return 1
    echo "Success fio tool rw"
    MESSAGE="PASS"
}

# fio tools mixed io read and write
# IN  : N/A
# OUT : N/A
function FIO_IO_RAIO_randrw()
{
    Test_Case_Title="FIO_IO_RAIO_randrw"

    # Generate FIO configuration file
    fio_config

    sed -i '/rw/a\rwmixread=' fio.conf
    sed -i '/rwmixread/a\bsrange=' fio.conf
    sed -i "{s/^bsrange=.*/bsrange=${BSRANGE}/g;}" fio.conf
    sed -i "{s/^rw=.*/rw=randrw/g;}" fio.conf

    for ratio in "${IO_RATIO[@]}"
    do
        echo "Begin FIO_IO_RAIO_randrw cycle: "${ratio}
        sed -i "{s/^rwmixread=.*/rwmixread=${ratio}/g;}" fio.conf
        fio fio.conf
        [ $? -ne 0 ] && MESSAGE="FAIL\tfio tool ${ratio} raio mixed io read and write failed." && echo "Fail fio tool "${ratio} & return 1
        echo "Success fio tool "${ratio}
    done
    MESSAGE="PASS"
}

# fio tools only io read-only write.
# IN  : N/A
# OUT : N/A
function FIO_IO_RAIO_read_write()
{
    Test_Case_Title="FIO_IO_RAIO_read_write"

    # Generate FIO configuration file
    fio_config

    sed -i '/rwmixread/a\bsrange=' fio.conf
    sed -i '/bsrange/a\bssplit=' fio.conf
    sed -i "{s/^bsrange=.*/bsrange=${BSRANGE}/g;}" fio.conf
    sed -i "{s/^bssplit=.*/bssplit=${BSSPLIT}/g;}" fio.conf

    for rw in read write
    do
        echo "Begin FIO IO RAIO rw cycle: "${rw}
        sed -i "{s/^rw=.*/rw=i${rw}/g;}" fio.conf
        fio fio.conf
        [ $? -ne 0 ] && MESSAGE="FAIL\tfio tool ${rw} io read and write failed." && echo "Fail fio tool "${rw} & return 1
        echo "Success fio tool "${rw}
    done

    MESSAGE="PASS"
}

function main()
{
    # call the implementation of the automation use cases
    test_case_function_run
}

main

main
