#!/bin/bash

g_pfn="${BASH_SOURCE[0]}"
g_fln=$(basename "${g_pfn}")
g_drPro=$(dirname "${g_pfn}")

g_drPro=$(cd "`dirname $0`" ; pwd)

. ${g_drPro}/../config/common_config
. ${g_drPro}/../config/common_lib

. ${g_drPro}/config/pcie_test_lib

echo ${g_drPro}
echo "begin to run pcie test"

RunTable "${g_flTCsTable}" "${g_flStatusTable}" "${g_dp_pcie_test_common}" "${g_flLog}"

#writeLogHeader
#GenReport "${g_flTCsTable}" "${g_flStatusTable}" PCIe "${g_flLog}"

#flStatusTable=$(basename "${g_flStatusTable}")
#GenTable "${g_flStatusTable}" "${g_flBaseLog}_${flStatusTable}" "PCIe" "${g_flLog}"

#####################

