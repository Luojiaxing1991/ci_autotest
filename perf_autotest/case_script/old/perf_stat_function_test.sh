#!/bin/bash

#N :N/A
#OUT:N/A

function fun_perf_list()
{
  :> pmu_event.txt
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > pmu_event.txt
  msum=$(cat pmu_event.txt | grep "hisi" | wc -l) 
  # cat pmu_event.txt
  if [[ $msum -le 0 ]];then
    mflag=0
    exit
  else 
    mflag=1
    echo 1
  fi

  if [ $mflag -eq 1 ];then
    set num = 1
    cat pmu_event.txt | while read myline
    do
      num=$[$num+1]
      echo "LINE"$num":"$myline
      perf stat -a -e $myline -I 200 sleep 10s 
    done
  fi 
}

function l3c_perf_stat_function_test()
{
    Test_Case_Title="L3C perf stat_function test"
    Test_Case_ID="PERF_FUNC_TEST_000"

    fun_perf_list hisi_l3c
}

function ddrc_perf_stat_function_test()
{
    Test_Case_Title="DDRC perf stat_function test"
    Test_Case_ID="PERF_FUNC_TEST_005"

    fun_perf_list hisi_ddrc
}

function mn_perf_stat_function_test()
{
    Test_Case_Title="MN perf stat_function test"
    Test_Case_ID="PERF_FUNC_TEST_010"

    fun_perf_list hisi_mn
}

function main()
{
    JIRA_ID="PV-1538"
    Test_Item="l3c mn ddrc"
    Designed_Requirement_ID="R.PERF.F001.A"
    
    l3c_perf_stat_function_test
    ddrc_perf_stat_function_test
    mn_perf_stat_function_test
}

main


