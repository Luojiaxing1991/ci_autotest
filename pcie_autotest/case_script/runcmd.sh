#!/bin/bash
RunCmds()
{
    varDicCols=${1}
    nCols=${2}
    varDicValues=${3}
    varFlLog=${4}
}

#fio --name=read --rw=read --bs=1M --runtime=30 --filename=/dev/nvme0n1 --numjobs=32 --iodepth=128 --direct=1 --sync=0 --norandommap --group_reporting --time_based
sCmd1='fio --name=${dic[0]} --rw=${dic[0]} --bs=${dic[1]} --runtime=30 --filename=/dev/nvme0n1 --numjobs=32 --iodepth=128 --direct=1 --sync=0 --norandommap --group_reporting --time_based'

m_dicValue=(
    [0]=read
    [1]=1M
)

RunCmds dic 2 m_dicValue m_flLog

#####################

