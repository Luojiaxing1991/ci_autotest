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
    dmesg | tail -200 > ${PERF_TOP_DIR}/data/log/irq_dmesg.txt
    irqstart=`cat ${PERF_TOP_DIR}/data/log/irq_dmesg.txt | grep "hisi_hrtimer_start PERF_IRQ_TEST irq" | wc -l`
    irqstop=`cat ${PERF_TOP_DIR}/data/log/irq_dmesg.txt | tail -150 | grep "hisi_hrtimer_stop PERF_IRQ_TEST irq" | wc -l`
    if [ $irqstart -lt 1 -a $irqstop -lt 1 ];then 
      MESSAGE="Fail\t $1 Event IRQ Function Test Fail!"
    else
      MESSAGE="Pass"
    fi
  fi
}

function l3c_perf_irq_function_test()
{
    Test_Case_Title="L3C perf irq function test"

    fun_perf_list hisi_l3c
}

function ddrc_perf_irq_function_test()
{
    Test_Case_Title="DDRC perf irq function test"

    fun_perf_list hisi_ddrc
}

function mn_perf_irq_function_test()
{
    Test_Case_Title="MN perf irq function test"

    fun_perf_list hisi_mn
}

function main()
{
    test_case_function_run
}

main
