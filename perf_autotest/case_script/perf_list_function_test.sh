#!/bin/bash

#N :N/A
#OUT:N/A

function l3c_perf_list_function_test()
{
  Test_Case_Title="L3C perf list function test"
  echo ${Test_Case_Title}
  msum=$(perf list | grep hisi_l3c| awk -F'[ \t]+' '{print $2}' | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail\t No L3C Perf Support Event!"
  else 
    MESSAGE="Pass"
    echo ${MESSAGE}
  fi
}

function ddrc_perf_list_function_test()
{
  Test_Case_Title="DDRC perf list function test"
  echo ${Test_Case_Title}
  msum=$(perf list | grep hisi_ddrc| awk -F'[ \t]+' '{print $2}' | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail\t No DDRC Perf Support Event!"
  else 
    MESSAGE="Pass"
    echo ${MESSAGE}
  fi
}

function mn_perf_list_function_test()
{
  Test_Case_Title="MN perf list function test"
  echo %{Test_Case_Title}
  msum=$(perf list | grep hisi_mn| awk -F'[ \t]+' '{print $2}' | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail\t No MN Perf Support Event!"
  else 
    MESSAGE="Pass"
    echo ${MESSAGE}
  fi
}

function main()
{
  test_case_function_run
}

main


