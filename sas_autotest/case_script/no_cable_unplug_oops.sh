#!/bin/bash


# Disk file data consistency test
# IN : N/A
# OUT: N/A
function disk_file_data_consistency_test()
{
    Test_Case_Title="disk_file_data_consistency_test"
    Test_Case_ID="ST.FUNC.051/ST.FUNC.052"

    time dd if=/dev/zero of=/opt/test.img bs=10M count=200 conv=fsync 1>/dev/null
    [ $? -ne 0 ] && writeFail "dd tools read data error." && return 1

    md5_init_value=`md5sum /opt/test.img | awk -F ' ' '{print $1}'`
    for disk_name in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${disk_name}
        if [ $? -ne 0 ]
        then
            umount ${disk_name}
            writeFail "Mount "${disk_name}" disk failure."
            return 1
        fi

        for i in `seq ${COMPARISON_NUMBER}`
        do
            cp /opt/test.img /mnt/test.img.$i
            md5_curr_value=`md5sum /mnt/test.img.$i | awk -F ' ' '{print $1}'`

            if [ x"${md5_init_value}" != x"${md5_curr_value}" ]
            then
                rm -f /opt/test.img
                umount ${disk_name}
                writeFail "The test.img(${init_value}) file is not equal to the MD5 value of the /mnt/test.img.${i}(${value}) file."
                return 1
            fi
            rm -f /mnt/test.img.$i
        done

        umount ${disk_name}
    done

    writePass
}

# Long time read / write disk.
# IN : N/A
# OUT: N/A
function loog_time_IO_read_write()
{
    Test_Case_Title="loog_time_IO_read_write"
    Test_Case_ID="ST.FUNC.055/ST.FUNC.057/ST.FUNC.058"

    sed -i "{s/^runtime=.*/runtime=${FIO_LONG_RUN_TIME}/g;}" fio.conf
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
    Test_Case_ID="ST.FUNC.015"

    sed -i "{s/^runtime=.*/runtime=${REPEAT_RM_TIME}/g;}" fio.conf
    for num in `seq ${REPEAT_RW_NUMBER}`
    do
        IO_read_write
        [ $? -eq 1  ] && writeFail "FIO tool repeatedly read and write disk failure." && return 1
    done
    writePass
}

function main()
{
    JIRA_ID="PV-1726"
    Test_Item="No cable unplug OOPs"
    Designed_Requirement_ID="R.SAS.N006.A"

    #Disk file data consistency test
    disk_file_data_consistency_test

    #Long time read / write disk.
    [ ${IS_LONG_TIME_IO_READ_WRITE} -eq 1 ] && loog_time_IO_read_write

    #Repeat read / write disk
    repeat_IO_read_write
}

main


