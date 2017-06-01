#!/bin/bash

# Load common function
. pcie_autotest/config/pcie_test_lib


# Main operation function
# IN : N/A
# OUT: N/A
function main()
{
    Module_Name="PCIE"
    
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
                echo "pcie_test_config file test case flag parameter configuration error."
                echo "please configure on and off."
                echo "on  - open test case."
                echo "off - close test case."
            ;;
       esac
    done
}

#Output log file header
writeLogHeader

main

# clean exit so lava-test can trust the results
exit 0

