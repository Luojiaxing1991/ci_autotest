#! /usr/bin/env python
import os
import sys
#para [1]: the path of target table place

#get the current path
pwd = os.path.split(os.path.realpath(__file__))[0]
targetdir = sys.argv[1]

if targetdir == '':
    print("target path is not provide!exit")
    sys.exit(0)

os.chdir(pwd)

#cp table_remake.py to target dir
os.system('cp table_remake.py %s'%targetdir)

#mv to target dir
os.chdir(targetdir)

os.system('python table_remake.py')

os.system('rm table_remake.py')

os.chdir(pwd)

