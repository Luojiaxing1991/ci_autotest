#!/bin/bash

#N :N/A
#OUT:N/A

function fun_perf_list()
{
  echo "Begin to run fun_perf_list"
  :> ${PERF_TOP_DIR}/data/log/pmu_event.txt
  pwd
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ${PERF_TOP_DIR}/data/log/pmu_event.txt
  msum=`cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep "hisi" | wc -l`
  echo ${msum}
  if [[ $msum -le 0 ]];then
    mflag=0
    echo "Test Fail in fun_perf_list when running perf list"
    MESSAGE="Fail"
    exit
  else 
    mflag=1
  fi

  if [ $mflag -eq 1 ];then
    rand=$(awk 'NR==2 {print $1}' ${PERF_TOP_DIR}/data/log/pmu_event.txt)
    rand2=$(awk 'NR==16 {print $1}' ${PERF_TOP_DIR}/data/log/pmu_event.txt)
    perf stat -a -e $rand -e $rand2 -I 200 sleep 10s
    echo "fun_perf_list Func run success!"
    MESSAGE="Pass"
  fi 
}

function l3c_perf_acpi_test()
{
    Test_Case_Title="L3C perf ACPI test"

    fun_perf_list hisi_l3c
}

function ddrc_perf_acpi_test()
{
    Test_Case_Title="DDRC perf ACPI test"

    fun_perf_list hisi_ddrc
}

function mn_perf_acpi_test()
{
    Test_Case_Title="MN perf ACPI test"

    fun_perf_list hisi_mn
}

function main()
{
    test_case_function_run
}

main
