#!/bin/bash

#N :N/A
#OUT:N/A

function l3c_perf_list_function_test()
{
  Test_Case_Title="L3C perf list function test"

  msum=$(perf list | grep hisi_l3c| awk -F'[ \t]+' '{print $2}' | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail"
  else 
    MESSAGE="Pass"
  fi
}

function ddrc_perf_list_function_test()
{
  Test_Case_Title="DDRC perf list function test"

  msum=$(perf list | grep hisi_ddrc| awk -F'[ \t]+' '{print $2}' | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail"
  else 
    MESSAGE="Pass"
  fi
}

function mn_perf_list_function_test()
{
  Test_Case_Title="MN perf list function test"

  msum=$(perf list | grep hisi_mn| awk -F'[ \t]+' '{print $2}' | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail"
  else 
    MESSAGE="Pass"
  fi
}

function main()
{
  test_case_function_run
}

main


