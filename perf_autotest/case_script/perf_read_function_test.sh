#!/bin/bash

#N :N/A
#OUT:N/A
# PERF_TOP_DIR="/root/shell"
function fun_perf_list()
{
  echo pwd ${PERF_TOP_DIR}
  :> ${PERF_TOP_DIR}/data/log/pmu_event.txt
  :> ${PERF_TOP_DIR}/data/log/counter_sum.txt
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ${PERF_TOP_DIR}/data/log/pmu_event.txt
  msum=$(cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep $1 | wc -l) 
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail\t No $1 Perf Support Event!"
    return
  else 
    myline=`sed -n '1p' ${PERF_TOP_DIR}/data/log/pmu_event.txt`
    perf stat -a -e $myline -I 200 sleep 10s >& ${PERF_TOP_DIR}/data/log/perf_statu.log
    cat ${PERF_TOP_DIR}/data/log/perf_statu.log | awk -F '[ \t]+'  '{print $3}' | sed 's/counts//g' | sed "s/,//g" |sed '/^[ \t]*$/d' > ${PERF_TOP_DIR}/data/log/counts.txt
    cat ${PERF_TOP_DIR}/data/log/counts.txt | while read myline
    do
      let sum+=myline
      echo $sum > ${PERF_TOP_DIR}/data/log/counter_sum.txt
    done
    if [ `sed -n '1p' ${PERF_TOP_DIR}/data/log/counter_sum.txt` -ge 0 ];then
      echo `devmem2 $2`
      MESSAGE="Pass"
    else
      MESSAGE="Fail\t $1 read test fail"
    fi
  fi
}

function l3c_perf_read_function_test()
{
  Test_Case_Title="L3C perf read function test"

  fun_perf_list hisi_l3c 0x90180170
}

function ddrc_perf_read_function_test()
{
  Test_Case_Title="DDRC perf read function test"

  fun_perf_list hisi_ddrc 0x94020384
}

function mn_perf_read_function_test()
{
  Test_Case_Title="MN perf read function test"

  fun_perf_list hisi_mn 0x0
}

function main()
{
  test_case_function_run
}

main
