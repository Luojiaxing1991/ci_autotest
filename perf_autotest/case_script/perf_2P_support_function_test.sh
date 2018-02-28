#!/bin/bash

#N :N/A
#OUT:N/A

ddrc_event=("flux_read/" "flux_read_cmd" "flux_write/" "flux_write_cmd" "fluxid_read/" "fluxid_read_cmd" "fluxid_write/"
  "fluxid_write_cmd" "read_latency_cnt0" "read_latency_cnt1" "read_latency_cnt_inher" "write_latency_cnt0" "write_latency_cnt1")
l3c_event=("read_allocate" "read_hit" "read_noallocate" "write_allocate" "write_hit" "write_noallocate")
mn_event=("dvm_op_req" "dvm_sync_req" "ec_barrier_req" "eo_barrier_req" "read_req" "write_req")

function perf_2P_support_function_test()
{
  echo ${Test_Case_Title}
  :> ${PERF_TOP_DIR}/data/log/2P_flag.txt
  msum=0
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ${PERF_TOP_DIR}/data/log/pmu_event.txt
  cat ${PERF_TOP_DIR}/data/log/pmu_event.txt
  echo $2
  case $2 in
    "l3c")
    for i in ${l3c_event[@]}; do
      if [ `cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep $i | wc -l` -eq 2 ];then
        echo 1 >> ${PERF_TOP_DIR}/data/log/2P_flag.txt
      else
        echo 0 >> ${PERF_TOP_DIR}/data/log/2P_flag.txt
        echo $i fail
      fi
    done
    ;;
    "ddrc")
    for j in ${ddrc_event[@]}; do
      if [ `cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep $j | wc -l` -eq 2 ];then
        echo 1 >> ${PERF_TOP_DIR}/data/log/2P_flag.txt
      else
        echo 0 >> ${PERF_TOP_DIR}/data/log/2P_flag.txt
        echo $j fail
      fi
    done
    ;;
    "mn")
    for k in ${mn_event[@]}; do
      if [ `cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep $k | wc -l` -eq 2 ];then
        echo 1 >> ${PERF_TOP_DIR}/data/log/2P_flag.txt
      else
        echo 0 >> ${PERF_TOP_DIR}/data/log/2P_flag.txt
        echo $k fail
      fi
    done
    ;;
  esac
  if [ `cat ${PERF_TOP_DIR}/data/log/2P_flag.txt | grep "0" | wc -l` -le 0 ];then
    MESSAGE="Pass"
    echo ${MESSAGE}
  else
    MESSAGE="Fail\t No L3C Perf 2P Support Event!"
  fi
}

function l3c_perf_2P_support_function_test()
{
  Test_Case_Title="L3C perf 2P support function test"
  perf_2P_support_function_test hisi_l3c[01]_1 l3c
}

function ddrc_perf_2P_support_function_test()
{
  Test_Case_Title="DDRC perf 2P support function test"
  perf_2P_support_function_test hisi_ddrc[01]_1 ddrc
}

function mn_perf_2P_support_function_test()
{
  Test_Case_Title="MN perf 2P support function test"
  perf_2P_support_function_test hisi_mn[01]_1 mn
}

function main()
{
  test_case_function_run
}

main