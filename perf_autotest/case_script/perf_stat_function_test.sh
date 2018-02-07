#!/bin/bash

#N :N/A
#OUT:N/A

function fun_perf_list()
{
  :> pmu_event.txt
  mflag=0
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ./data/log/pmu_event.txt
  msum=$(cat ./data/log/pmu_event.txt | grep $1 | wc -l) 
  if [[ $msum -le 0 ]];then
    mflag=0
    MESSAGE="Fail"
  else 
    mflag=1
  fi

  if [ $mflag -eq 1 ];then
    set num = 1
    cat ./data/log/pmu_event.txt | while read myline
    do
      num=$[$num+1]
      echo "LINE"$num":"$myline
      perf stat -a -e $myline -I 200 sleep 10s 
    done
    MESSAGE="Pass"
  fi 
}

function l3c_perf_stat_function_test()
{
    Test_Case_Title="L3C perf stat function test"

    fun_perf_list hisi_l3c
}

function ddrc_perf_stat_function_test()
{
    Test_Case_Title="DDRC perf stat function test"

    fun_perf_list hisi_ddrc
}

function mn_perf_stat_function_test()
{
    Test_Case_Title="MN perf stat function test"

    fun_perf_list hisi_mn
}

function main()
{
    test_case_function_run
}

main


