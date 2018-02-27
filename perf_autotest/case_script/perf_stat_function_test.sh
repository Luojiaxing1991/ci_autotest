#!/bin/bash
#!/bin/athena/bash

#N :N/A
#OUT:N/A

function fun_perf_list()
{
  :> ${PERF_TOP_DIR}/data/log/pmu_event.txt
  :> ${PERF_TOP_DIR}/data/log/test_flag.txt
  trap - INT
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ${PERF_TOP_DIR}/data/log/pmu_event.txt
  msum=$(cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep $1 | wc -l) 
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail\t No $1 Perf Support Event!"
    return
  else 
    cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | while read myline
    do
      perf stat -a -e $myline -I 200 sleep 10s >& ${PERF_TOP_DIR}/data/log/perf_statu.log
      cat ${PERF_TOP_DIR}/data/log/perf_statu.log | awk -F '[ \t]+'  '{print $3}' | sed 's/counts//g' > ${PERF_TOP_DIR}/data/log/counts.txt
      sleep 1
      if [ `cat ${PERF_TOP_DIR}/data/log/counts.txt | grep -i "not" | wc -l` -le 0 ];then 
	echo 1 >> ${PERF_TOP_DIR}/data/log/test_flag.txt
	echo pass
	# break
      else
	echo 0 >> ${PERF_TOP_DIR}/data/log/test_flag.txt
        echo fail
	MESSAGE="Fail\t $1 Event Run Error!"	
        break
      fi
    done
    if [ `cat ${PERF_TOP_DIR}/data/log/test_flag.txt | grep "0" | wc -l` -le 0 ];then
      MESSAGE="Pass"
      echo Pass
    fi
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
