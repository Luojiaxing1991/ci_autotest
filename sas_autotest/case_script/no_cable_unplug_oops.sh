#!/bin/bash


# Disk file data consistency test
# IN : N/A
# OUT: N/A
function disk_file_data_consistency_test()
{
    Test_Case_Title="disk_file_data_consistency_test"

    time dd if=/dev/zero of=/opt/test.img bs=10M count=200 conv=fsync 1>/dev/null
    [ $? -ne 0 ] && MESSAGE="FAIL\tdd tools read data error." && return 1

    md5_init_value=`md5sum /opt/test.img | awk -F ' ' '{print $1}'`
    for disk_name in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${disk_name}
        if [ $? -ne 0 ]
        then
            umount ${disk_name}
            MESSAGE="FAIL\tMount "${disk_name}" disk failure."
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
                MESSAGE="FAIL\tThe test.img(${init_value}) file is not equal to the MD5 value of the /mnt/test.img.${i}(${value}) file."
                return 1
            fi
            rm -f /mnt/test.img.$i
        done

        umount ${disk_name}
    done
    MESSAGE="PASS"
}

# Long time read / write disk.
# IN : N/A
# OUT: N/A
function loog_time_IO_read_write()
{
    Test_Case_Title="loog_time_IO_read_write"

    sed -i "{s/^runtime=.*/runtime=${FIO_LONG_RUN_TIME}/g;}" fio.conf
    echo "Begin to IO rw with runtime: "${FIO_LONG_RUN_TIME}
    IO_read_write
    [ $? -eq 1 ] && MESSAGE="FAIL\tFIO tool long read and write disk failure." && return 1
    MESSAGE="PASS"
}

# Repeat read / write disk
# IN : N/A
# OUT: N/A
function repeat_IO_read_write()
{
    Test_Case_Title="repeat_IO_read_write"

    sed -i "{s/^runtime=.*/runtime=${REPEAT_RM_TIME}/g;}" fio.conf
    for num in `seq ${REPEAT_RW_NUMBER}`
    do
        IO_read_write
        [ $? -eq 1  ] && MESSAGE="FAIL\tFIO tool repeatedly read and write disk failure." && return 1
    done
    MESSAGE="PASS"
}

function main()
{
    #Get system disk partition information.
    fio_config

    # call the implementation of the automation use cases
    test_case_function_run
}

main

#disk_file_data_consistency_test

