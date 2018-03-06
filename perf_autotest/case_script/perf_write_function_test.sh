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
    dmesg | tail -200 | grep -i "PERF_WRITE_TEST:" > ${PERF_TOP_DIR}/data/log/write_dmesg.txt
    cat ${PERF_TOP_DIR}/data/log/write_dmesg.txt | awk -F '[ \t]+'  '{print $6}' > ${PERF_TOP_DIR}/data/log/write_data.txt
    cat ${PERF_TOP_DIR}/data/log/write_data.txt | sed "s/,//g" |sed '/^[ \t]*$/d' > ${PERF_TOP_DIR}/data/log/write_data.txt
    if [ `cat ${PERF_TOP_DIR}/data/log/write_dmesg.txt | grep -i "PERF_WRITE_TEST:" | wc -l` -lt 1 ];then 
      MESSAGE="Fail\t $1 Event WRITE Function Test Fail!"
    else
      header=`sed -n -e '1p' ${PERF_TOP_DIR}/data/log/write_data.txt`
      footer=`sed -n -e '$p' ${PERF_TOP_DIR}/data/log/write_data.txt`
      if [ $((16#$footer)) -lt $((16#$header)) ];then
        MESSAGE="Fail\t $1 Event WRITE Function Test Fail,data error!"
      else
        MESSAGE="Pass"
      fi
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
