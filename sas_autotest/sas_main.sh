#!/bin/bash



# Load common function
. sas_autotest/config/sas_test_lib


# Main operation function
# IN : N/A
# OUT: N/A
function main()
{
    Module_Name="SAS"
    
    for key in "${!case_map[@]}"
    do
        echo $key " : " ${case_map[$key]}
        case "${case_map[$key]}" in
            on)
                commd="${key}.sh"
                source $TEST_CASE_PATH/$commd
            ;;
            off)
            ;;
            *)
                echo "sas_test_config file test case flag parameter configuration error."
                echo "please configure on and off."
                echo "on  - open test case."
                echo "off - close test case."
            ;;
       esac
    done
}

#Output log file header
writeLogHeader

# Get all disk partition information
get_all_disk_part

main

# clean exit so lava-test can trust the results
exit 0

