#!/bin/bash

PRE_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load the public configuration library
. ${PRE_TOP_DIR}/../config/common_config
. ${PRE_TOP_DIR}/../config/common_lib

#****Check cmd support before running prepare actions for plinth test*****#

#Check efibootmgr



#modify the boot order to Self disk reboot
#modifyBootOrder

exit 0

