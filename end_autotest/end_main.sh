#!/bin/bash

END_TOP_DIR=$(cd "`dirname $0`" ; pwd)

# Load the public configuration library
. ${END_TOP_DIR}/../config/common_config
. ${END_TOP_DIR}/../config/common_lib



rm ${END_TOP_DIR}/../pre_autotest/ok.log

#Recover the Boot order for CI
#recoverBootOrder

exit 0

