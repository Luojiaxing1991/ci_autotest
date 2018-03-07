#!/bin/bash

#N :N/A
#OUT:N/A
function fun_configure_test()
{
  mevent=`sed -n -e '1p' ${PERF_TOP_DIR}/data/log/pmu_event.txt`
  echo $mevent
  perf stat -a -e $mevent -I 200 sleep 10s
  dmesg | tail -153 | grep -i "PERF_WRITE_TEST REG:" > ${PERF_TOP_DIR}/data/log/configure_dmesg.txt
  cat ${PERF_TOP_DIR}/data/log/configure_dmesg.txt | awk -F '[ \t]+'  '{print $7}' > ${PERF_TOP_DIR}/data/log/configure_data.txt
  # cat ${PERF_TOP_DIR}/data/log/configure_data.txt | sed "s/,//g" |sed '/^[ \t]*$/d' > ${PERF_TOP_DIR}/data/log/configure_data.txt
  if [ `cat ${PERF_TOP_DIR}/data/log/configure_dmesg.txt | grep -i "PERF_WRITE_TEST REG:" | wc -l` -lt 1 ];then 
    MESSAGE="Fail\t $1 Event Configure Function Test Fail!"
  else
    mreg=`sed -n -e '1p' ${PERF_TOP_DIR}/data/log/configure_data.txt`
    let mreg-=$1
    echo $mreg
    if [ $mreg -ne 0 ];then
      MESSAGE="Fail\t PERF Event Configure Function Test Fail!"
    else
      MESSAGE="Pass"
    fi
  fi
}
function fun_perf_list()
{
  :> ${PERF_TOP_DIR}/data/log/pmu_event.txt
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ${PERF_TOP_DIR}/data/log/pmu_event.txt
  msum=$(cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep $1 | wc -l)
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail\t No $1 Perf Support Event!"
    return
  else
    case $1 in
    "hisi_l3c") 
      fun_configure_test 170
    ;;
    "hisi_ddrc")
      fun_configure_test 384
    ;;
    "hisi_mn")
      fun_configure_test 38
    ;;
    esac
  fi
}

function l3c_perf_configure_function_test()
{
    Test_Case_Title="L3C perf configure function test"

    fun_perf_list hisi_l3c
}

function ddrc_perf_configure_function_test()
{
    Test_Case_Title="DDRC perf configure function test"

    fun_perf_list hisi_ddrc
}

function mn_perf_configure_function_test()
{
    Test_Case_Title="MN perf configure function test"

    fun_perf_list hisi_mn
}

function main()
{
    test_case_function_run
}

main
