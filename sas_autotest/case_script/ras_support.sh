#!/bin/bash


#
#
#
function 1bit_ecc_injection()
{
    Test_Case_Title="1bit_ecc_injection"
    Test_Case_ID=""

    # Generate FIO configuration file
    fio_config

    ${DEVMEM} ${MASK_REG_ADDR_VALUE} w 0x1
    trshdce_value=`${DEVMEM} ${TRSHDC_REG_ADDR_VALUE} w`
    for reg in ${1BIT_ECC_REG_VALUE[@]}
    do
        1bit_begin_count=`dmesg | grep ${ECC_INFO_KEY_QUERIES} | wc -l`
        ${DEVMEM} ${INJECT_REG_ADDR_VALUE} w 0x1
        fio fio.conf &
        sleep 10

        ${DEVMEM} ${INJECT_REG_ADDR_VALUE} w 0x0
        cnt_value=`${DEVMEM} ${CNT_REG_ADDR_VALUE} w`
        1bit_mid_count=`dmsg | grep ${ECC_INFO_KEY_QUERIES} | wc -l`
        if [ ${1bit_begin_count} -gt ${1bit_mid_count}  ] || [ x"${cnt_value}" == x" ${trshdce_value}"  ]
        then
            writeFail "${CNT_REG_ADDR_VALUE} register address setting ${reg}, no error message is reported."
            return 1
        fi
        wait

        1bit_end_count=`dmsg | grep ${ECC_INFO_KEY_QUERIES} | wc -l`
        cnt_end_value=`${DEVMEM} ${CNT_REG_ADDR_VALUE} w`

        if [ ${1bit_mid_count} -ne ${1bit_end_count} ] || [ x"${cnt_value}" != x" ${cnt_end_value}" ]
        then
            writeFail "${CNT_REG_ADDR_VALUE} register address setting ${reg}, shutdown error repoted log failed."
            return 1
        fi
    done

    ${DEVMEM} ${MASK_REG_ADDR_VALUE} w 0x0
    ${DEVMEM} ${INJECT_REG_ADDR_VALUE} w 0x0

    writePass
}


function main()
{
    JIRA_ID="PV-1330"
    Test_Item="RAS support"
    Designed_Requirement_ID="R.SAS.F025A"

    1bit_ecc_injection
}

main

