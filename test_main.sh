#!/bin/bash

###########################################
# the main entry, use to run all test work.
###########################################

TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load configuration file
. config/common_config
. config/common_lib


# Update boot Image file
# IN : N/A
# OUT: N/A
function update_image()
{
    [ ! -e ${IMAGE_FILE} ] && echo "${IMAGE_FILE} file does not exist, do not update the Image file" && return 1
    cp ${IMAGE_FILE} ${IMAGE_DIR_PATH}
    [ $? != 0 ] && echo "Update Image failed." && return 1
}

# connect the board and run test script
# IN : $1 board no
#      $2 test run script
# OUT: N/A
function board_run_back()
{
    #Setting up a single board default startup system.
    #cp ~/grub-back.cfg ~/grub.cfg
    sed -i "{s/^set\ default=.*/set\ default=${BACK_BOARD_GRUB_DEFAULT}/g;}" ~/grub.cfg
    board_reboot $1
    [ $? != 0 ] && echo "board reboot failed." && return 1
    
    expect -c '
    set timeout -1
    set boardno '$1'
    set user '${SYSTEM_USER}'
    set passwd '${SYSTEM_PASSWD}'
    set server_user '{$SERVER_USER}'
    set server_passwd '${SERVER_PASSWD}'
    set SERVER_IP '${SERVER_IP}'
    set unzip_dir '${TOP_DIR}'
    spawn board_connect ${boardno}
    send "\r"
    expect -re {Press any other key in [0-9]+ seconds to stop automatical booting}
    send "\r"
    send "\r"
    expect -re "login:"
    send "${user}\r"
    expect -re "Password:"
    send "${passwd}\r"
    sleep 5
    expect -re ":.*#"

    send "echo `ifconfig eth0|grep -Po \"(?<=(inet addr:))(.*)(?=(Bcast))\"` >backIP.txt\r"
    expect -re ".*#"
    # cp test script to server
    send "rm -f ~/.ssh/known_hosts\r"
    send "rm -f ~/.ssh/authorized_keys\r"
    send "scp backIP.txt ${server_user}@${SERVER_IP}:${unzip_dir}\r"
    expect -re "Are you sure you want to continue connecting (yes/no)?"
    send "yes\r"
    expect -re "password:"
    send "${server_passwd}\r"		
    expect -re ":.*#"
    '

    export BACK_IP=`cat backIP.txt|sed s/[[:space:]]//g`
    #cfg_file=./xge_autotest/config/xge_test_config
    sed -i '/^BACK_IP.*/d' ${XGE_MODULE_CFG_FILE} && echo BACK_IP="$BACK_IP" >>${XGE_MODULE_CFG_FILE}
    sed -i '/^BACK_IP.*/d' ${PCIE_MODULE_CFG_FILE} && echo BACK_IP="$BACK_IP" >>${PCIE_MODULE_CFG_FILE}
    cd ~/
    tar -zcvf  ${AUTOTEST_ZIP_FILE} ${TOP_DIR}
    [ $? != 0 ] && echo "tar test script failed." && return 1
    #cp ~/grub-host.cfg ~/grub.cfg
    cd ${TOP_DIR}
    return 0
}

# connect the board and run test script
# IN : $1 board no
#      $2 test run script
# OUT: N/A
function board_run()
{
    #Setting up a single board default startup system.
    sed -i "{s/^set\ default=.*/set\ default=${BOARD_GRUB_DEFAULT}/g;}" ~/grub.cfg
    board_reboot $1
    [ $? != 0 ] && echo "board reboot failed." && return 1

    unzip_dir=`echo ${TOP_DIR#*/}`
    expect -c '
    set timeout -1
    set boardno '$1'
    set user '${SYSTEM_USER}'
    set passwd '${SYSTEM_PASSWD}'
    set server_user '{$SERVER_USER}'
    set server_passwd '${SERVER_PASSWD}'
    set test_run_script '$2'
    set SERVER_IP '${SERVER_IP}'
    set autotest_zip '${AUTOTEST_ZIP_FILE}'
    set report_file '${REPORT_FILE}'
    set mode_report_file '$3'
    set unzip_dir '${unzip_dir}'
    spawn board_connect ${boardno}
    send "\r"
    expect -re {Press any other key in [0-9]+ seconds to stop automatical booting}
    send "\r"
    send "\r"
    expect -re "login:"
    send "${user}\r"
    expect -re "Password:"
    send "${passwd}\r"
    sleep 8
    expect -re ":.*#"
    # cp test script from server
    send "rm -f ~/.ssh/known_hosts\r"
    send "scp ${server_user}@${SERVER_IP}:~/${autotest_zip} ~/\r"
    expect -re "Are you sure you want to continue connecting (yes/no)?"
    send "yes\r"
		
    expect -re "password:"
    send "${server_passwd}\r"
		
    expect -re ":.*#"
    send "cd ~/;tar -zxvf ${autotest_zip}\r"
    expect -re ":.*#"
    send "cd ~/${unzip_dir};bash -x ${test_run_script}\r"
    expect -re ":.*#"
    send "rm -f ~/.ssh/known_hosts\r"
    send "scp ${report_file} ${server_user}@${SERVER_IP}:/${unzip_dir}/report/${mode_report_file}\r"
    expect -re "Are you sure you want to continue connecting (yes/no)?"
    send "yes\r"

    expect -re "password:"
    send "${server_passwd}\r"
    expect -re ":.*#"
    send "cd ~;rm -rf ${unzip_dir};rm -rf ${autotest_zip}\r"
    expect -re ":.*#"
    '
}

# Main operation function
# IN : N/A
# OUT: N/A
function main()
{
    #update image
    #update_image
    killall ipmitool >/dev/null

    cd ~/
    tar -zcvf  ${AUTOTEST_ZIP_FILE} ${TOP_DIR}
    [ $? != 0 ] && echo "tar test script failed." && return 1

    cd ${TOP_DIR}
    #Output log file header
    #echo "Module Name,JIRA ID,Test Item,Test Case Title,Test Result,Remark" > ${REPORT_FILE}

    if [ ${RUNING_ENV_TYPE} -eq 1 ]
    then
        #SAS Module Main function call
        [ ${RUN_SAS} -eq 1 ] && board_run ${SAS_BORADNO} ${SAS_MAIN} ${SAS_REPORT_FILE} &
        #PXE Module Main function call
        [ ${RUN_XGE} -eq 1 ] &&  board_run_back ${BACK_XGE_BORADNO} && board_run ${XGE_BORADNO} ${XGE_MAIN} ${XGE_REPORT_FILE} &
        #PCIE Module Main function call
        [ ${RUN_PCIE} -eq 1 ] && board_run_back ${BACK_PCIE_BORADNO} && board_run ${PCIE_BORADNO} ${PCIE_MAIN} ${PCIE_REPORT_FILE} &	
    else
        bash -x ${SAS_MAIN} ${SAS_REPORT_FILE} &
	bash -x ${XGE_MAIN} ${XGE_REPORT_FILE} &
	bash -x ${PCIE_MAIN} ${PCIE_REPORT_FILE} &	
    fi

    # Wait for all background processes to end
    wait
}

main

# clean exit so lava-test can trust the results
exit 0

