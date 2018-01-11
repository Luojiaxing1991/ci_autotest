#!/bin/bash



# Supports full disk read and write simultaneously 
# IN :N/A
# OUT:N/A
function support_max_devices()
{
    Test_Case_Title="support_max_devices"
    Test_Case_ID="ST.FUNC.004"

    num=${#ALL_DISK_PART_NAME[@]}
    [ ${num} -ne ${MAX_DEV_NUM} ] && writeFail "expander not fully loaded." && return 1

    count=0
    for disk_name in "${ALL_DISK_PART_NAME[@]}"
    do
        mkdir /mnt/${count}
        echo "y" | mkfs.ext4 ${disk_name} 1>/dev/null
        mount -t ext4 ${disk_name} /mnt/${count} 1>/dev/null

        info=`mount | grep -w "^${disk_name}"`
        [ "${info}" = x"" ] && writeFail "Mount "${disk_name}" disk failure." && return 1

        time dd if=${disk_name} of=/mnt/${count}/test.img bs=1M count=1000 conv=fsync 1>/dev/null &
        [ $? -ne 0 ] && umount ${disk_name} && writeFail "dd tools read ${disk_name} error." && return 1
        let count+=1
    done

    wait
    for((dir=0;dir<${count};++dir))
    do
        umount /mnt/${dir}
        rm -rf /mnt/${dir}
    done
    writePass
}

function main()
{
    JIRA_ID="PV-1945"
    Test_Item="R.SAS.F004.A"
    Designed_Requirement_ID="Support Max Devices"

    support_max_devices
}

main

