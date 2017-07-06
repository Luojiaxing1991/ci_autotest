#!/bin/bash

#run the PCIe 3.0 feature by P3600 SSD card on No.204 D05 board
# IN :N/A
# OUT:N/A
function support_pcie3.0_p3600_test()
{
    Test_Case_Title="support_pcie3.0_p3600_test"
    Test_Case_ID="ST.FUNC.023"
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
    umount "$Mount_Path"

     ./${PCIE_TOP_DIR}/../common_tool/fio --name=randread --numjobs=32 --filename=/dev/$P3600_Disk --rw=randread --iodepth=128 -ioengine=libaio \
    --direct=1 --sync=0 --norandommap --group_reporting --runtime=300 --time_base --bs=2M >/dev/null
    if [ $? -ne 0 ]
    then
        writeFail "No, fail, run fio by intel P3600 SSD failed!"
        return 1
    fi
    writePass
}

function support_pcie3.0_raid3008_test()
{
    Test_Case_Title="support_pcie3.0_raid3008_test"
    Test_Case_ID="ST.FUNC.023"
    RAID3008_NAME="Symbios Logic SAS3008"
    RAID3008_Disk="sda |sdb |sdc |sdd |sde |sdf |sdg |sdh "
    RAID3008_Disk_Path="/dev/sda"
    Mount_Path="/mnt/sda"


    RC_Base_Addr_RAID3008_D05="0x8a0090080"
    RAID3008_Mem_Addr=`devmem "$RC_Base_Addr_RAID3008_D05"`
    X8_gen3=`echo "$RAID3008_Mem_Addr" |cut -c5-6`
    if [ x"$X8_gen3" == x"" ]
    then
        writeFail "The AR requirement of $RAID3008_NAME PCIe gen3 build link failure."
        return 1
    fi

    enumerate=`lspci -k |grep "$RAID3008_NAME"`
    if [ x"$enumerate" == x"" ]
    then
        writeFail "The AR requirtment of $RAID3008_NAME PCIe gen3 enumerate failure."
        return 1
    fi

    lsblk_raid3008=`lsblk |grep -E "$RAID3008_Disk" |awk '{print $1}'`
    if [ x"$lsblk_raid3008" == x"" ]
    then
        writeFail "The AR requirtment of $RAID3008_NAME PCIe gen3 find RAID3008 about sdx disk failure."
        return 1
    fi

    #fdisk & mount RAID3008

    #sudo mkfs.ext4 -f "$RAID3008_Disk_Path"
    echo "y" | mkfs.ext4 "$RAID3008_Disk_Path" 1>/dev/null
    mount -t ext4 "$RAID3008_Disk_Path" "$Mount_Path" 1>/dev/null

    mount_info=`mount | grep "$RAID3008_Disk_Path"`
    if [ "$mount_info" == x"" ]
    then
        writeFail "The AR requirement of $RAID3008_NAME PCIe gen3 fdisk&mount $RAID3008_Disk_Path failure."
        return 1
    fi

    cp ~/*.sh "$Mount_Path"
    if [ $? -ne 0 ]
    then
        writeFail "The AR requirement of $RAID3008_NAME PCIe gen3 cp function failure."
        return 1
    fi

     ./${PCIE_TOP_DIR}/../common_tool/fio --name=randread --numjobs=1 --filename=$RAID3008_Disk_Path --rw=randread --iodepth=128 -ioengine=libaio \
    --direct=1 --sync=0 --norandommap --group_reporting --runtime=300 --time_base --bs=2M >/dev/null
    if [ $? -ne 0 ]
    then
        writeFail "No, fail, run fio by LSI RAID3008 failed!"
        return 1
    fi
    writePass
}


function main()
{
    JIRA_ID="PV-1416"
    Test_Item="pcie3.0_support_test"
    Designed_Requirement_ID="R.PCIE.F070.A"

    support_pcie3.0_p3600_test
    support_pcie3.0_raid3008_test
}

main

