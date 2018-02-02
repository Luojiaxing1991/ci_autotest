#! /usr/bin/env python

import os
import sys

#find out if the path of bin is including the lava-test-case
#if so ,exit this script
#if not,cp the lava-test-case into bin
if os.path.exists('/usr/local/bin/lava-test-case'):
    sys.exit(0)    

pwd = os.path.split(os.path.realpath(__file__))[0]

#pwd = '/lava-hip06-d03/tests/0_febnuhsngtefe784985nfe83nf84/ci_interface/if'
#the target addr is /lava-hip06-d03/bin

#get all dir name using / to split,the result like:[' ' 'lava-hip06-d03' 'tests']
tmp1 = pwd.split("/")

#pop the ' ' in tmp1 array
tmp1.pop(0)

tmpLen = 0

for name in tmp1:
    if name == 'tests':
        break
    tmpLen = tmpLen + len(name) + 1

#the targetdir is like: /lava-hip06-d03
targetdir='%s/bin'%pwd[0:tmpLen]

print(targetdir)

if os.path.exists('%s/lava-test-case'%targetdir):
    os.system('cp -r %s/lava-test-case /usr/local/bin'%targetdir)
    os.system('ls -a /usr/local/bin')
    print('Add the lava-test-case into path success!')
else:
    print('Can not find the file: lava-test-case!')
