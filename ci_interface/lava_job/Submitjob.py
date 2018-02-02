#! /usr/bin/env python

#parameter:
#   [1] target json file to be submit,this file should be exit in the same dir with this py

import os

import sys

import commands

#save the path of json
jsonfile = 'job_No_Submit.json'#sys.argv[1]

pwd = os.path.split(os.path.realpath(__file__))[0]


# we check the json file is exist or not
if os.path.exists('%s/%s'%(pwd,jsonfile)) == False:
    print('json file is not exist!')
    sys.exit(0)

target = '%s/%s'%(pwd,jsonfile)

#check if the command lava-tool is exist or not
res,stat = commands.getstatusoutput('which lava-tool')

#call the lava-tool to submit the job
if res == 0:
   # print('lava-tool submit-job http://default@192.168.3.100:8089/RPC2/ %s'%target)
    os.system('lava-tool submit-job http://default@192.168.3.100:8089/RPC2/ %s'%target)
else:
    print('lava-tool command is not exist')
