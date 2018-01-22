#!/bin/bash

g_pfn="${BASH_SOURCE[0]}"
g_fln=$(basename "${g_pfn}")
g_drPro=$(dirname "${g_pfn}")

flPub1=$(find "${g_drPro}" -type f -name "*.common")
if [ -z "${flPub1}" ]; then
    printf "%s[%3d]%5s: Not found file\n" "${FUNCNAME[0]}" ${LINENO} "Error" >&2
    exit 1
fi
$(sed "s#^#. #" <<< "${flPub1}")

flLoad1=${g_fn_testcase_common%%.*}.pair.cfg
LoadSourceFileParent "${g_dp_testcase_common}" "${flLoad1}" flPath1 true
$(sed "s#^#. #" <<< "${flPath1}")

#####################
#do
DoAll g_dicVarKeys

#####################

