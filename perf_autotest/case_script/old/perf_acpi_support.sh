#!/bin/bash

#N :N/A
#OUT:N/A

function fun_perf_list()
{
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
    perf stat -a -e $rand -e $rand2 -I 200 sleep 10s
    echo pass
  fi 
}

function l3c_perf_acpi_test()
{
    Test_Case_Title="L3C perf ACPI test"
    Test_Case_ID="PERF_FUNC_TEST_110"

    fun_perf_list hisi_l3c
}

function ddrc_perf_acpi_test()
{
    Test_Case_Title="DDRC perf ACPI test"
    Test_Case_ID="PERF_FUNC_TEST_120"

    fun_perf_list hisi_ddrc
}

function mn_perf_acpi_test()
{
    Test_Case_Title="MN perf ACPI test"
    Test_Case_ID="PERF_FUNC_TEST_120"

    fun_perf_list hisi_mn
}

function main()
{
    JIRA_ID="PV-1531"
    Test_Item="l3c ddrc mn"
    Designed_Requirement_ID="R.PERF.F022.A"

    acpi_flag=$(cat /proc/cmdline | grep acpi=force | wc -l)
    if [ $acpi_flag -eq 1 ];then
      l3c_perf_acpi_test
      ddrc_perf_acpi_test
      mn_perf_acpi_test
    fi
}

main