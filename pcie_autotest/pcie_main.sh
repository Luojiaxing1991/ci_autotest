#!/bin/bash

g_pfn="${BASH_SOURCE[0]}"
g_fln=$(basename "${g_pfn}")
g_drPro=$(dirname "${g_pfn}")

echo ${g_drPro}

. ${g_drPro}/config/pcie_test_lib

echo "begin to run pcie test"

#####################
#do
flStatusTable=$(basename "${g_flStatusTable}")
f_flStatusMidTable=${g_flBaseLog}.${flStatusTable}
f_flStatusMidTableExcel=${f_flStatusMidTable}.excel

RunTable "${g_flTCsTable}" "${f_flStatusMidTable}" "${g_dp_pcie_test_common}" "${g_flLog}"

#writeLogHeader
#GenReport "${g_flTCsTable}" "${f_flStatusMidTable}" PCIe "${g_flLog}"

GenTable "${g_flTCsTable}" "${f_flStatusMidTable}" "${f_flStatusMidTableExcel}" "PCIe" "${g_flLog}"

g_sMsgCur="result file:
    ${REPORT_FILE}
    ${f_flStatusMidTable}
    ${f_flStatusMidTableExcel}
"
echo "${g_sMsgCur}" >> "${g_flLog}"

#####################

