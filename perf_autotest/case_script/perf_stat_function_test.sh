#!/bin/bash
#!/bin/athena/bash

#N :N/A
#OUT:N/A

function fun_perf_list()
{
  :> ./data/log/pmu_event.txt
  trap - INT
  mflag=0
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > ${PERF_TOP_DIR}/data/log/pmu_event.txt
  msum=$(cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | grep $1 | wc -l) 
  if [[ $msum -le 0 ]];then
    MESSAGE="Fail\t No $1 Perf Support Event!"
    return
  else 
    cat ${PERF_TOP_DIR}/data/log/pmu_event.txt | while read myline
    do
      perf stat -a -e $myline -I 200 sleep 10s >& ./data/log/perf_statu.log
      cat ./data/log/perf_statu.log | awk -F '[ \t]+'  '{print $3}' | sed 's/counts//g' > ./data/log/counts.txt
      sleep 1
      if [ `cat ./data/log/counts.txt | grep -i "not" | wc -l` -le 0 ];then 
        mflag=1
	echo pass
      else
        mflag=0
        echo fail	
        return
      fi
    done
    echo mflag $mflag
    if [ $mflag -eq 1 ];then
      MESSAGE="pass"
    else
      MESSAGE="Fail\t $1 Event Run Error!"
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
