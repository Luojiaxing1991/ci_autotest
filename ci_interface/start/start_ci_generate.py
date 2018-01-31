#! /usr/bin/env python

import os

pwd = os.path.split(os.path.realpath(__file__))[0]

print('The start ci generate py is locate in: %s'%pwd)

target = os.path.abspath(os.path.join(pwd,"../../.."))

print('Cp to target dir in: %s'%target)

runfile = 'UpdataCiTestRepo.py'

#cp the Update py out of git 
os.system('cp -rf %s/%s %s '%(pwd,runfile,target))

if os.path.exists('%s/%s'%(target,runfile)):
    print('py file cp success!')
    os.chdir(target)
    os.system('python %s'%runfile)
else:
    print('py file is not exist!')

os.system('rm -fr %s'%runfile)

