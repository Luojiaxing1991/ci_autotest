#!/bin/bash

ROCE_TOP_DIR=$( cd "`dirname $0`" ; pwd )
ROCE_CASE_DIR=${ROCE_TOP_DIR}/case_script

# Load module configuration library
. ${ROCE_TOP_DIR}/config/roce_test_config
. ${ROCE_TOP_DIR}/config/roce_test_lib

# Load the public configuration library
. ${ROCE_TOP_DIR}/../config/common_config
. ${ROCE_TOP_DIR}/../config/common_lib


# Main operation function
# IN : N/A
# OUT: N/A
function main()
{
    Module_Name="ROCE"

    for key in "${!case_map[@]}"
    do
        case "${case_map[$key]}" in
            on)
                commd="${key}.sh"
                source ${ROCE_CASE_DIR}/$commd
            ;;
            off)
            ;;
            *)
                echo "roce_test_config file test case flag parameter configuration error."
                echo "please configure on or off."
                echo "on  - open test case."
                echo "off - close test case."
            ;;
       esac
    done
}

# Output log file header
writeLogHeader

Init_Net_Ip

TrustRelation ${BACK_IP}
copy_tool_so

main

# These characters are used to mark the end
echo "testmain finish"

# clean exit so lava-test can trust the results
exit 0

