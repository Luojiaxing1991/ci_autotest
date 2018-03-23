#!/bin/bash

PRE_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load the public configuration library
. ${PRE_TOP_DIR}/../config/common_config
. ${PRE_TOP_DIR}/../config/common_lib

envok=1

#****Check cmd support before running prepare actions for plinth test*****#

#Check efibootmgr



#****Clone the repo of kernel and build it
#cd ${PRE_TOP_DIR}

#cd into the repo
tmp=`echo ${KERNEL_GITADDR} | awk -F'.' '{print $2}' | awk -F'/' '{print $NF}'`
echo "The name of kernel repo is "$tmp

if [ ! -d "/home/kernel/${tmp}" ];then
	echo "The kernel dir is not exit! Begin to clone repo!"
        mkdir /home/kernel
        cd /home/kernel
        git clone ${KERNEL_GITADDR}
else
	echo "The kernel repo have been found!"
fi

cd /home/kernel/${tmp}

git branch | grep ${BRANCH_NAME}

if [ $? -eq 0 ];then
	#The same name of branch is exit
	git checkout -b tmp_luo origin/${BRANCH_NAME}
	git branch -D ${BRANCH_NAME}
fi

git checkout -b ${BRANCH_NAME} origin/${BRANCH_NAME}
git branch -D tmp_luo

echo "Begin to build the kernel!"
bash build.sh d05 > ${PRE_TOP_DIR}/ok.log

echo "Finish the kernel build!"

if [ ! -d "/home/kernel/output" ];then
	echo "The output dir to save ko is not exit, mkdir!"
	mkdir /home/kernel/output
fi

#copy the ko to specified folder : /home/kernel/output
cp -f drivers/infiniband/hw/hns/hns-roce-hw-v1.ko /home/kernel/output/
cp -f drivers/infiniband/hw/hns/hns-roce.ko /home/kernel/output/

if [ -f "/home/kernel/output/hns-roce.ko" ];then
	echo "Finish copy the ko to output dir!"
else
	echo "No found the ko file!Maybe the build is fail!"
        lava_report "CI plinth Test prepare: Fail to generate ko file!" fail
       	envok=0 
fi

#copy the Image to bootdisk to support disk reboot
if [ ! -d "/home/kernel/a1" ];then
	mkdir /home/kernel/a1
fi

mount /dev/sda1 /home/kernel/a1
cp -f arch/arm64/boot/Image /home/kernel/a1
cp -rf ${PRE_TOP_DIR}/../ci_interface/install/a1/* /home/kernel/a1

if [ -f "/home/kernel/a1/Image" ];then
	echo "Finish copy the Image to output dir!"
else
	echo "No found the Image file!Maybe the build is fail!"
        lava_report "CI plinth Test prepare: Fail to generate Image file!" fail
        envok=0
fi


#if test env prepare is ok or not
if [ $envok -eq 0 ];then
	echo "some error happen when construct test env!"
	rm ${PRE_TOP_DIR}/ok.log
else
	echo "Test env contruction is success!"
	lava_report "CI plinth Test prepare: Success" pass
fi


exit 0

