#!/bin/bash

g_pfn="${BASH_SOURCE[0]}"
g_fln=$(basename "${g_pfn}")
g_drPro=$(dirname "${g_pfn}")

flPub1=$(find "${g_drPro}" -type f -name "testcase.common")
if [ -z "${flPub1}" ]; then
    printf "%s[%3d]%5s: Not found file\n" "${FUNCNAME[0]}" ${LINENO} "Error" >&2
    exit 1
fi
$(sed "s#^#. #" <<< "${flPub1}")

flLoad1=common_config
LoadSourceFileParent "${g_dp_testcase_common}" "${flLoad1}" flPath1 false
if [ -z "${flPath1}" ]; then
    LoadSourceFileParent "${g_dp_testcase_common}/.." "${flLoad1}" flPath1 true
fi
$(sed "s#^#. #" <<< "${flPath1}")

flLoad1=common_lib
LoadSourceFileParent "${g_dp_testcase_common}" "${flLoad1}" flPath1 false
if [ -z "${flPath1}" ]; then
    LoadSourceFileParent "${g_dp_testcase_common}/.." "${flLoad1}" flPath1 true
fi
$(sed "s#^#. #" <<< "${flPath1}")

flLoad1=pcie_test_config
LoadSourceFileParent "${g_dp_testcase_common}" "${flLoad1}" flPath1 false
if [ -z "${flPath1}" ]; then
    LoadSourceFileParent "${g_dp_testcase_common}/.." "${flLoad1}" flPath1 true
fi
$(sed "s#^#. #" <<< "${flPath1}")

#####################
#do
pwd |grep -q "/plinth-autotest\$"
if [ $? -ne 0 ]; then
    export REPORT_FILE=${g_flBaseLog}.csv
fi

${g_flTCRun}

writeLogHeader

TranslateTable()
{
    local sPass sFail sNone sStatus1 sSearch1 sMessage 
    sPass=$(echo "${g_statusPass}" |sed 's/\([][]\)/\\\1/g')
    sFail=$(echo "${g_statusFail}" |sed 's/\([][]\)/\\\1/g')
    sNone=$(echo "${g_statusNone}" |sed 's/\([][]\)/\\\1/g')

    local f_sTCsList
    f_sTCsList=$(cat "${g_flTCsList}")${g__n}

    local Module_Name JIRA_ID Designed_Requirement_ID Test_Case_ID Test_Item Test_Case_Title
    Module_Name="PCIE"
    while read sR1; do
        sStatus1=$(echo "${sR1}" |awk -F'\t' '{print $1}')
        sSearch1=$(echo "${sR1}" |awk -F'\t' '{print $2}')
        sMessage=$(echo "${sR1}" |awk -F'\t' '{print $3}')
        sTCLine1=$(grep -i "${sSearch1}" "${g_flTCsList}")
        sTCLine1=$(echo "${sTCLine1}" |sed "s/\r\+//g")
        if [ -n "${sTCLine1}" ]; then
            JIRA_ID=$(echo "${sTCLine1}" |awk -F'\t' '{print $1}')
            Designed_Requirement_ID=$(echo "${sTCLine1}" |awk -F'\t' '{print $2}')
            Test_Case_ID=$(echo "${sTCLine1}" |awk -F'\t' '{print $3}')
            Test_Item=$(echo "${sTCLine1}" |awk -F'\t' '{print $4}')
            Test_Case_Title=$(echo "${sTCLine1}" |awk -F'\t' '{print $5}')
            echo "${sStatus1}" |grep -q "^${sPass}\$"
            if [ $? -eq 0 ]; then
                writePass
            else
                echo "${sStatus1}" |grep -q "^${sFail}\$"
                if [ $? -eq 0 ]; then
                    writeFail "${sMessage}"
                fi
            fi
            f_sTCsList=$(echo "${f_sTCsList}" |sed "/${sSearch1}/s/^/${sStatus1}${g_sSplit}/")
        else
            sStatus1=${g_statusNone}
            f_sTCsList=$(echo "${f_sTCsList}" |sed "\${a ${sStatus1}${g_sSplit}${sSearch1}${g__n}q};")
        fi
    done < "${g_flBaseLog}_${g_flStatusTable}"

    echo "${f_sTCsList}" > "${g_flBaseLog}.${g_flStatusTable}"
}

TranslateTable

#####################

