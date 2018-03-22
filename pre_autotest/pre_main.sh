#!/bin/bash

PRE_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load the public configuration library
. ${PRE_TOP_DIR}/../config/common_config
. ${PRE_TOP_DIR}/../config/common_lib

#****Check cmd support before running prepare actions for plinth test*****#

#Check efibootmgr



#****Clone the repo of kernel and build it
#cd ${PRE_TOP_DIR}

#cd into the repo
tmp=`echo ${KERNEL_GITADDR} | awk -F'.' '{print $2}' | awk -F'/' '{print $NF}'`
echo "The name of kernel repo is "$tmp

cd ${PRE_TOP_DIR}/../../${tmp}

git branch | grep ${BRANCH_NAME}

if [ $? -eq 0 ];then
	#The same name of branch is exit
	git checkout -b tmp_luo origin/${BRANCH_NAME}
	git branch -D ${BRANCH_NAME}
fi

git checkout -b ${BRANCH_NAME} origin/${BRANCH_NAME}
git branch -D tmp_luo

bash build.sh

#modify the boot order to Self disk reboot
#modifyBootOrder

exit 0

