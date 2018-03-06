#!/bin/bash

#N :N/A
#OUT:N/A

function fun_perf_list()
{
  :> ${PERF_TOP_DIR}/data/log/pmu_event.txt
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ${PERF_TOP_DIR}/data/log/pmu_event.txt
  msum=$(cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep $1 | wc -l)
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail\t No $1 Perf Support Event!"
    return
  else 
    rand=$(awk 'NR==2 {print $1}' ${PERF_TOP_DIR}/data/log/pmu_event.txt)
    perf stat -a -e $rand -I 200 sleep 10s
    dmesg | tail -150 > ${PERF_TOP_DIR}/data/log/en_dmesg.txt
    en_flag=`cat ${PERF_TOP_DIR}/data/log/en_dmesg.txt | grep "hisi_uncore_pmu_enable_v2" | wc -l`
    dis_flag=`cat ${PERF_TOP_DIR}/data/log/en_dmesg.txt | grep "hisi_uncore_pmu_disable_v2" | wc -l`
    if [ $en_flag -lt 1 -a $dis_flag -lt 1 ];then 
      MESSAGE="Fail\t $1 Event disable/enable Function Test Fail!"
    else
      MESSAGE="Pass"
    fi
  fi
}

function l3c_perf_enable_function_test()
{
    Test_Case_Title="L3C perf disable/enable function test"

    fun_perf_list hisi_l3c
}

function mn_perf_enable_function_test()
{
    Test_Case_Title="MN perf disable/enable function test"

    fun_perf_list hisi_mn
}

function main()
{
    test_case_function_run
}

main
