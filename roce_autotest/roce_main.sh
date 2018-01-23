#!/bin/bash

# Load common function
. roce_autotest/config/roce_test_lib


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
                source $TEST_CASE_PATH/$commd
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

TrustRelation ${BACK_IP}
copy_tool_so
main

echo "testmain finish"
# clean exit so lava-test can trust the results
exit 0

