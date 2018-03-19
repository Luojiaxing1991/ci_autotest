#!/bin/bash



# ecc error injection during the execution, is there an error message is reported.
# IN : $1 - ecc error register value.
#      $2 - ecc error register address.
#      $3 - bit injected value, '0x1' means 1bit, '0x11' means 2bit.
#OUT : return 0 means success.
#      return 1 means error injection did not report information.
#      return 2 close error injection failed.
function ecc_injection_process()
{
    ECC_BIT_REG_INJECT_VALUE=$1
    INJECT_REG_ADDR_VALUE=$2
    INJECT_BIT_VALUE=$3

    # Generate FIO configuration file
    fio_config

    sed -i "{s/^runtime=.*/runtime=${BIT_ECC_TIME}/g;}" fio.conf
    ${DEVMEM} ${MASK_REG_ADDR_VALUE} w ${INJECT_BIT_VALUE}
    if [ x"${BOARD_TYPE}" == x"D06" ]
    then
        trshdce_value=`${DEVMEM} ${TRSHDC_REG_ADDR_VALUE} w`
    fi

    # clear the contents of the ring buffer.
    time dmesg -c > /dev/null

    begin_bit_count=`dmesg | grep ${ECC_INFO_KEY_QUERIES} | wc -l`
    ${DEVMEM} ${INJECT_REG_ADDR_VALUE} w ${ECC_BIT_REG_INJECT_VALUE}
    ${SAS_TOP_DIR}/../${COMMON_TOOL_PATH}/fio fio.conf &
    sleep 10
    ${DEVMEM} ${INJECT_REG_ADDR_VALUE} w 0x0
    mid_bit_count=`dmesg | grep ${ECC_INFO_KEY_QUERIES} | wc -l`

    if [ x"${BOARD_TYPE}" == x"D06" ]
    then
        cnt_value=`${DEVMEM} ${CNT_REG_ADDR_VALUE} w`
        if [ ${begin_bit_count} -eq ${mid_bit_count} ] && [ x"${cnt_value}" == x"${trshdce_value}" ]
        then
            wait
            return 1
        fi
    else
        if [ ${begin_bit_count} -eq ${mid_bit_count}  ]
        then
            wait
            return 1
        fi
    fi
    wait

    end_bit_count=`dmesg | grep ${ECC_INFO_KEY_QUERIES} | wc -l`

    if [ x"${BOARD_TYPE}" == x"D06" ]
    then
        cnt_end_value=`${DEVMEM} ${CNT_REG_ADDR_VALUE} w`
        if [ ${mid_bit_count} -ne ${end_bit_count} ] || [ x"${cnt_value}" != x"${cnt_end_value}" ]
        then
            return 2
        fi
    else
        if [ ${mid_bit_count} -ne ${end_bit_count} ]
        then
            return 2
        fi
    fi

    return 0
}

# ecc error register output.
# IN : $1 - register injection return value.
#      $2 - register address
#      $3 - register injection value.
# OUT: N/A
function output_ecc_info()
{
    REG_RETURN_VALUE=$1
    REG_ADDR_VALUE=$2
    REG_ECC_VALUE=$3

    case "${REG_RETURN_VALUE}" in
        0)
            MESSAGE="PASS"
            ;;
        1)
            MESSAGE="FAIL\t${REG_ADDR_VALUE} register address setting ${reg}, no error message is reported."
            ;;
        2)
            MESSAGE="FAIL\t${REG_ADDR_VALUE} register address setting ${reg}, shutdown error repoted log failed."
            ;;
    esac
}

# 1bit ecc error register 0 injection.
# IN  : $1 - register injection value.
# OUT : N/A
function 1bit_ecc_inject0_en()
{
    Test_Case_Title="1bit_ecc_inject0_en"
    reg_value=$1

    ecc_injection_process "${reg_value}" "${INJECT0_REG_ADDR_VALUE}" "0x1"
    return_num=$?
    output_ecc_info ${return_num} ${INJECT0_REG_ADDR_VALUE} ${reg_value}

    ${DEVMEM} ${MASK_REG_ADDR_VALUE} w 0x0

    if [ x"${BOARD_TYPE}" == x"D06" ]
    then
        # restore register initial value.
        ${DEVMEM} ${INJECT0_REG_ADDR_VALUE} w 0x0
        ${DEVMEM} ${INJECT1_REG_ADDR_VALUE} w 0x0
    fi
}

# 1bit ecc error register 1 injection.
# IN  : N/A
# OUT : N/A
function 1bit_ecc_inject1_en()
{
    Test_Case_Title="1bit_ecc_inject1_en"
    reg_value=$1

    ecc_injection_process "${reg_value}" ${INJECT1_REG_ADDR_VALUE} "0x1"
    return_num=$?
    output_ecc_info ${return_num} ${INJECT1_REG_ADDR_VALUE} ${reg_value}

    ${DEVMEM} ${MASK_REG_ADDR_VALUE} w 0x0

    if [ x"${BOARD_TYPE}" == x"D06"  ]
    then
        # restore register initial value.
        ${DEVMEM} ${INJECT0_REG_ADDR_VALUE} w 0x0
        ${DEVMEM} ${INJECT1_REG_ADDR_VALUE} w 0x0
    fi
}

# 2bit ecc error register injection.
# IN  : N/A
# OUT : N/A
function 2bit_ecc_injection()
{
    Test_Case_Title="2bit_ecc_injection"
    reg_value=$1

    ecc_injection_process "${reg_value}" "${INJECT1_REG_ADDR_VALUE}" "0x11"
    return_num=$?
    output_ecc_info ${return_num} ${INJECT1_REG_ADDR_VALUE} ${reg_value}

    ${DEVMEM} ${MASK_REG_ADDR_VALUE} w 0x0

    if [ x"${BOARD_TYPE}" == x"D06"  ]
    then
        # restore register initial value.
        ${DEVMEM} ${INJECT0_REG_ADDR_VALUE} w 0x0
        ${DEVMEM} ${INJECT1_REG_ADDR_VALUE} w 0x0
    fi
}

function main()
{
    info=`echo ${TEST_CASE_FUNCTION_NAME} | awk -F '_' '{print $NF}'`
    TEST_CASE_FUNCTION_NAME=`echo ${TEST_CASE_FUNCTION_NAME%_*}`
    echo "The using function name is "${TEST_CASE_FUNCTION_NAME}
    TEST_CASE_FUNCTION_NAME="${TEST_CASE_FUNCTION_NAME} 0x${info}"

    # call the implementation of the automation use cases
    test_case_function_run
}

main
