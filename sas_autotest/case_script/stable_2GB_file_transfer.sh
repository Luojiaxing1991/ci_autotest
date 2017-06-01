#!/bin/bash

# File transfer stability test
# IN : N/A
# OUT: N/A
function iozne_file_transfer_stability_test()
{
    Test_Case_Title="iozne_file_transfer_stability_test"
    Test_Case_ID="ST.FUNC.049/ST.FUNC.050"

    for disk_name in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${disk_name} 
        if [ $? -ne 0 ]
        then
            writeFail "Mount "$disk_name" disk failure."
            return 1
        fi

        ./$COMMON_TOOL_PATH/iozone -a -n 1g -g 10g -i 0 -i 1 -i 2 -f /mnt/iozone -V 5aa51ff1 1 > $ERROR_INFO 2>&1
        status=$?
        info=`grep -iw 'error' $ERROR_INFO`
        if [ x"$info" == x"" ] && [ $status -ne 0 ]
        then
            writeFail "File transfer stability test,IO read and write exception."
            umount $disk_name
            return 1
        fi

        umount $disk_name
        rm -f $ERROR_INFO
    done

    writePass 
}

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
            writeFail "Mount "$disk_name" disk failure."
            return 1
        fi
        
        for i in `seq $COMPARISON_NUMBER`
        do
            cp /opt/test.img /mnt/test.img.$i
            md5_curr_value=`md5sum /mnt/test.img.$i | awk -F ' ' '{print $1}'`

            if [ x"$md5_init_value" != x"$md5_curr_value" ]
            then
                rm -f /opt/test.img
                umount $disk_name
                writeFail "The test.img($init_value) file is not equal to the MD5 value of the /mnt/test.img.$i($value) file."
                return 1
            fi
            rm -f /mnt/test.img.$i
        done
        umount $disk_name
    done

    writePass
}

function main()
{
    JIRA_ID="PV-926"
    Test_Item="Stable 2GB file transfer"
    Designed_Requirement_ID="R.SAS.N007.A"

    iozne_file_transfer_stability_test

    disk_file_data_consistency_test
}

main


