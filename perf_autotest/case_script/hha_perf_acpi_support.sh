#!/bin/bash

#N :N/A
#OUT:N/A

function fun_perf_list()
{
  :> ${PERF_TOP_DIR}/data/log/pmu_event.txt
  mflag=0
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ${PERF_TOP_DIR}/data/log/pmu_event.txt
  msum=`cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep "hisi" | wc -l`
  cat $msum $mflag
  if [ `cat /proc/cmdline | grep "acpi=force" | wc -l` -ne 1 ];then
    mflag=0
    MESSAGE="Fail\t No ACPI Support!"
  else
    if [ $msum -le 0 ];then
      mflag=0
      MESSAGE="Fail\t No $1 Perf Evnet Support!"
    else 
      mflag=1
    fi
  fi

  if [ $mflag -eq 1 ];then
    rand=$(awk 'NR==2 {print $1}' ${PERF_TOP_DIR}/data/log/pmu_event.txt)
    rand2=$(awk 'NR==16 {print $1}' ${PERF_TOP_DIR}/data/log/pmu_event.txt)
    perf stat -a -e $rand -e $rand2 -I 200 sleep 10s
    MESSAGE="Pass"
    echo ${MESSAGE}
  fi 
}

function hha_perf_acpi_test()
{
    Test_Case_Title="Support HHA PMU events"

    fun_perf_list hisi_hha
}

function main()
{
    test_case_function_run
}

main
