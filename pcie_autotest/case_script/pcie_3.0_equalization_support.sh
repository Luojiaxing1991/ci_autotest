#!/bin/bash

#run teh PCIe 3.0 equlization feature by P3600 SSD card on No.204 D05 board
# IN :N/A
# OUT:N/A
function support_pcie3.0_equalization_p3600_test()
{
    Test_Case_Title="support_pcie3.0_equalization_p3600_test"
    Test_Case_ID="ST.FUNC.025"
    P3600_NAME="Intel Corporation Device 0953"
    P3600_Disk="nvme0n1"
    P3600_Disk_Path="/dev/nvme0n1"
    Mount_Path="/mnt/p3600"    


    RC_Base_Addr_P3600_D05="0x700a0200080"
    P3600_Mem_Addr=`devmem "$RC_Base_Addr_P3600_D05"`
    X4_gen3=`echo "$P3600_Mem_Addr" |cut -c5-6`
    if [ x"$X4_gen3" == x"" ]
    then
        writeFail "The AR requirement of $P3600_NAME PCIe gen3 build link failure."
        return 1
    fi

    enumerate=`lspci -k |grep "$P3600_NAME"`
    if [ x"$enumerate" == x"" ]
    then
        writeFail "The AR requirtment of $P3600_NAME PCIe gen3 enumerate failure."
        return 1
    fi

    lsblk_p3600=`lsblk |grep "$P3600_Disk" |awk '{print $1}'`
    if [ x"$lsblk_p3600" == x"" ]
    then
        writeFail "The AR requirtment of $P3600_NAME PCIe gen3 find nvme0n1 disk failure."
        return 1
    fi

    #fdisk & mount p3600
    
    #sudo mkfs.ext4 -f "$P3600_Disk_Path"
    echo "y" | mkfs.ext4 "$P3600_Disk_Path" 1>/dev/null
    mount -t ext4 "$P3600_Disk_Path" "$Mount_Path" 1>/dev/null

    mount_info=`mount | grep "$P3600_Disk_Path"`
    if [ "$mount_info" == x"" ]
    then
        writeFail "The AR requirement of $P3600_NAME PCIe gen3 fdisk&mount $P3600_Disk_Path failure."
        return 1
    fi
    
    cp ~/*.sh "$Mount_Path"
    if [ x"$?" == x"1" ]
    then
        writeFail "The AR requirement of $P3600_NAME PCIe gen3 cp function failure."
        return 1
    fi

    fio --name=randread --numjobs=32 --filename=/dev/$P3600_Disk --rw=randread --iodepth=128 -ioengine=libaio \
    --direct=1 --sync=0 --norandommap --group_reporting --runtime=300 --time_base --bs=2M >/dev/null
    if [ $? -ne 0 ]
    then
        writeFail "No, fail, run fio by intel P3600 SSD failed!"
        return 1
    fi
    writePass
}

function main()
{
    JIRA_ID="PV-320"
    Test_Item="pcie3.0-equalization-p3600-test"
    Designed_Requirement_ID="R.PCIE.F011A"

    support_pcie3.0_equalization_p3600_test
}

main

