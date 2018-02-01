#!/bin/bash


# module load and uninstall.
# IN : N/A
# OUT: N/A
function module_load_uninstall()
{
    Test_Case_Title="module_load_uninstall"
    Test_Case_ID="ST.FUNC.200/ST.FUNC.201"

    for ko in `echo ${MODULE_KO_FILE} | sed 's/|/ /g'`
    do
        insmod ${ko}
        return_num=$?
        info=`lsmod | grep ${ko%.*}`

        if [ ${return_num} -ne 0 -o x"${info}" == x"" ]
        then
            writeFail "insmod load ${ko} fail."
            return 1
        fi
    done

    #Get system disk partition information.
    get_all_disk_part
    [ ${#ALL_DISK_PART_NAME[@]} -eq 0 ] && writeFail "load ko file, identify the disk failed" && return 1

    #Mount the disk partition to the local.
    for dev in "${ALL_DISK_PART_NAME[@]}"
    do
        mount_disk ${dev}
        return_num=$?
        [ ${return_num} -ne 0 ] && writeFail "failed to mount \"${dev}\"" && return 1
        umount ${dev}
    done

    for ko in `echo ${MODULE_KO_FILE} | sed 's/|/ /g'`
    do
        rmmod ${ko}
        return_num=$?
        info=`lsmod | grep ${ko%.*}`

        if [ ${return_num} -ne 0 -o x"${info}" == x"" ]
        then
            writeFail "rmmod uninstall  ${ko} fail."
            return 1
        fi
    done

    writePass
}

function main()
{
    JIRA_ID="N/A"
    Test_Item="Support module load"
    Designed_Requirement_ID="N/A"

    module_load_uninstall
}

main

