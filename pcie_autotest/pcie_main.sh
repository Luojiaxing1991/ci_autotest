#!/bin/bash


PCIE_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load common function
. ${PCIE_TOP_DIR}/config/pcie_test_config
. ${PCIE_TOP_DIR}/config/pcie_test_lib

# Load the public configuration library
. ${PCIE_TOP_DIR}/../config/common_config
. ${PCIE_TOP_DIR}/../config/common_lib


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
                source ${PCIE_TOP_DIR}/case_script/$commd
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

#
setTrustRelation

main

# clean exit so lava-test can trust the results
exit 0

