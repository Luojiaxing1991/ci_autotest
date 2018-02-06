#!/bin/bash

function fun_perf_list()
{
  perf list | grep $1| awk -F'[ \t]+' '{print $2}' > pmu_event.txt
  cat pmu_event.txt | while read myline
  do
    echo "LINE"$num":"$myline
    perf stat -a -e $myline -I 200 sleep 10s 
  done 
}

function main()
{
    fun_perf_list hisi_ddrc0_1
}

main
