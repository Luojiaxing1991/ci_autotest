#!/bin/bash

#N :N/A
#OUT:N/A

function l3c_perf_list_function_test()
{
  Test_Case_Title="L3C perf stat_function test"
  Test_Case_ID="PERF_FUNC_TEST_015"

  msum=$(perf list | grep hisi_l3c| awk -F'[ \t]+' '{print $2}' | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    echo fail
    exit
  else 
    echo pass
  fi
}

function ddrc_perf_list_function_test()
{
  Test_Case_Title="DDRC perf stat_function test"
  Test_Case_ID="PERF_FUNC_TEST_020"

  msum=$(perf list | grep hisi_ddrc| awk -F'[ \t]+' '{print $2}' | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    echo fail
    exit
  else 
    echo pass
  fi
}

function mn_perf_list_function_test()
{
  Test_Case_Title="MN perf stat_function test"
  Test_Case_ID="PERF_FUNC_TEST_015"

  msum=$(perf list | grep mn| awk -F'[ \t]+' '{print $2}' | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    echo fail
    exit
  else 
    echo pass
  fi
}

function main()
{
    JIRA_ID="PV-1549"
    Test_Item="l3c mn ddrc"
    Designed_Requirement_ID="R.PERF.F002.A"
    
    l3c_perf_list_function_test
    ddrc_perf_list_function_test
    mn_perf_list_function_test
}

main


