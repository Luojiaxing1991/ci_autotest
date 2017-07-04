#!/bin/bash


XGE_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load common function
. ${XGE_TOP_DIR}/config/xge_test_config
. ${XGE_TOP_DIR}/config/xge_test_lib

# Load the public configuration library
. ${XGE_TOP_DIR}/../config/common_config
. ${XGE_TOP_DIR}/../config/common_lib


# Main operation function
# IN : N/A
# OUT: N/A
function main()
{
    Module_Name="XGE"
    
    for key in "${!case_map[@]}"
    do
        case "${case_map[$key]}" in
            on)
                commd="${key}.sh"
                source ${XGE_TOP_DIR}/case_script/$commd
            ;;
            off)
            ;;
            *)
                echo "xge_test_config file test case flag parameter configuration error."
                echo "please configure on and off."
                echo "on  - open test case."
                echo "off - close test case."
            ;;
       esac
    done
}

# Output log file header
writeLogHeader

# 
setTrustRelation

main

# clean exit so lava-test can trust the results
exit 0

