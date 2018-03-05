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
    rand2=$(awk 'NR==16 {print $1}' ${PERF_TOP_DIR}/data/log/pmu_event.txt)
    perf stat -a -e $rand -e $rand2 -I 200 sleep 10s >& ${PERF_TOP_DIR}/data/log/perf_statu.log
    if [ `cat ${PERF_TOP_DIR}/data/log/perf_statu.log | grep -i "L3C_PERF_WRITE_TEST:" | wc -l` -le 1 ];then 
      MESSAGE="Fail\t $1 Event IRQ Function Test Fail!"
    else
      sed 's/^[ \t]*L3C_PERF_WRITE_TEST:[ \t]*//' <<< "${sLine}"
      MESSAGE="Pass"
    fi
  fi
}

function l3c_perf_write_function_test()
{
    Test_Case_Title="L3C perf write function test"

    fun_perf_list hisi_l3c
}

function ddrc_perf_write_function_test()
{
    Test_Case_Title="DDRC perf write function test"

    fun_perf_list hisi_ddrc
}

function mn_perf_write_function_test()
{
    Test_Case_Title="MN perf write function test"

    fun_perf_list hisi_mn
}

function main()
{
    test_case_function_run
}

main
