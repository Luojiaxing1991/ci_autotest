* [Introduction](#1)
* [Preparation](#2)
   * [Automation scripts via openlab Environment](#2.1)
   * [Automation scripts via board Environment](#2.2)

<br/><br/>

<h2 id="1">Introduction</h2> 

*plinth-autotest* is designed to optimize the test work of each module and improve the efficiency of each module testing.
It is divided into three modules: SAS, HNS and PCIE and can only be runned in The openlab1.0 and openlab2.0 environment. 
After running autotest scripts, we can automatically start and connect target board, and automatically runs the test 
cases for the modules in target boards.

*plinth-autotest* Directory structure description：<br/>
```bash
├── Readme.md                        //  Fix readme file.
├── common_tool                      //  Common test tools.
├── config                           //  Common test configuration.
│   ├── common_config                //  Common configuration of test script running enviroment and target boards.
│   └── common_lib                   //  Common test function.
│
├── sas_autotest                     //  SAS module test scripts.
│   ├── case_script
│   ├── config
│   └── sas_main.sh
│
├── xge_autotest                     //  XGE module test scripts.
│   ├── case_script
│   ├── config
│   └── xge_main.sh
│
├── pcie_autotest                    //  PCIE module test scripts.
│   ├── case_script
│   ├── config
│   └── pcie_main.sh
│
├── report                           //  Storing automatic test results for each module.
│
└── test_main.sh                     //  The main running script calls the entry scripts for each module.
```
<br/>


<h2 id="2">Preparation</h2> 

<h3 id="2.1">Automation scripts via openlab Environment</h3>

a. Configuring the “config/common_config” file.<br/>
* All module public configuration items：<br/>
```bash
   SERVER_IP                         //  the automated script running environment's IP address.
   SERVER_USER                       //  automatic script runing environment's user name.
   SERVER_PASSWD                     //  automatic script runing environment's user password.
   BOARD_GRUB_DEFAULT                //  According to the startup item in 'grub.cfg' file,Configure the host board boot environment
   BACK_BOARD_GRUB_DEFAULT           //  According to the startup item in 'grub.cfg' file,Configure the backup board boot environment
```
* SAS module configuration item：<br/>
```bash
   RUN_SAS                           //  config 1 to run sas test case, 0 to cancle sas test case, Default is 1.
   SAS_BORADNO                       //  the host board number for board_connect.
```
* HNS module configuration item：<br/>
```bash
   RUN_XGE                           //  config 1 to run hns test case, 0 to cancle hns test case, Default is 1.
   XGE_BORADNO                       //  the host board number for board_connect.
   BACK_XGE_BORADNO                  //  the backup board number for board_connect.
``` 

* PCIE module configuration item：<br/>
```bash
   RUN_PCIE                          //  config 1 to run pcie test case, 0 to cancle pcie test case, Default is 1.
   PCIE_BORADNO                      //  the host board number for board_connect.
   BACK_PCIE_BORADNO                 //  the backup board number for board_connect.
```

* Configuration sample：<br/>
e.g.: <br/>
```bash 

#!/bin/bash

# Module test run switch, 1 - open test case, 0 - close test case, Default is 1.
RUN_SAS=1
RUN_XGE=0
RUN_PCIE=0

# IMAGE Configuration item.
IMAGE_FILE=common_tool/Image
IMAGE_DIR_PATH=~/tftp

## Common Configuration item.
SERVER_IP=192.168.1.107
SERVER_USER=name
SERVER_PASSWD=passwd
# Single board environment username and password.
SYSTEM_USER=root
SYSTEM_PASSWD=root


REPORT_PATH=~/autotest/report
REPORT_FILE=report.csv
AUTOTEST_ZIP_FILE=autotest.tar.gz
# Setting up a single board default startup system.
BOARD_GRUB_DEFAULT=minilinux-D05
# The SAS module does not need to be configured.
BACK_BOARD_GRUB_DEFAULT=

# SAS Module Configuration item.
SAS_MAIN=sas_autotest/sas_main.sh
SAS_REPORT_FILE=sas_report.csv
# Start single board number.
SAS_BORADNO=2

```
b. Execute command“bash -x test_main.sh”.<br/><br/>

<h3 id="2.2">Automation scripts via board Environmentt</h3>
a. Start the board that needs to be tested and upload the autotest script tarball to the board.<br/>
e.g.: <br>
```bash

scp plinth_autotest.tar.gz root@192.168.1.243:~/

```

b. Run the main script of the module that needs to be tested.<br/>
e.g.: <br>
```bash

root@ubuntu:~# tar -zxvf plinth_autotest.tar.gz
root@ubuntu:~# cd plinth-autotest/sas_autotest/
root@ubuntu:~/plinth-autotest/sas_autotest# bash -x sas_main.sh

```
