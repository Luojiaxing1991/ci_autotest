#!/bin/bash

#N :N/A
#OUT:N/A

function hha_perf_acpi_test()
{
    Test_Case_Title="HHA perf ACPI test"
    Test_Case_ID="PERF_FUNC_TEST_115"

    :> pmu_event.txt
    perf list | grep $1| awk -F'[ \t]+' '{print $2}' > pmu_event.txt
    msum=`cat pmu_event.txt | grep "hisi" | wc -l`
    if [[ $msum -le 0 ]];then
      mflag=0
      echo fail:perf list is null
      exit
    else 
      mflag=1
    fi

    if [ $mflag -eq 1 ];then
      rand=$(awk 'NR==2 {print $1}'  pmu_event.txt)
      rand2=$(awk 'NR==16 {print $1}'  pmu_event.txt)
      perf stat -a -e $rand -e $rand2 -I 200 sleep 10s > perf_stat.txt
      echo pass
    fi
}


function main()
{
    JIRA_ID="PV-1584"
    Test_Item="hha"
    Designed_Requirement_ID="R.PERF.F023.A"

    acpi_flag=$(cat /proc/cmdline | grep acpi=force | wc -l)
    if [ $acpi_flag -eq 1 ];then
      hha_perf_acpi_test hisi_hha
    fi
}