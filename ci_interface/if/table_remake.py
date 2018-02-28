#! /usr/bin/env python
# -*- coding: utf-8 -*-

import io
import os
import sys

#this python is to remake the table file which in same dir
#if there is no table fiel or more than one table file ,return false

#first get the current path of this py
pwd = os.path.split(os.path.realpath(__file__))[0]
print('pwd is %s'%pwd)

#then we find out if there is table file
tablenum = 0
pathlist = os.listdir(pwd)
for filename in pathlist:
    if filename.endswith('table'):
        tablenum = tablenum + 1
        target = filename
        if tablenum >= 2 :
            print('table file is more than 1! exit')
            sys.exit(0)

print("One table file exist! continue: ")

#backup the org table
#os.system('cp %s/%s %s/org -f'%(pwd,target,pwd))

#if os.path.exists('%s/org'%pwd):
#    print('org backup success!')
#else:
#    print('org backup fail!')
#    sys.exit(0)

#replate the tab to blank  in table
f =open('%s/%s'%(pwd,target),'r')
linelist=[]
for line in f:
    str=line.replace('\t','@!').rstrip()
    str=str + " "
    str=str.replace('@!on@!','@!off@!').rstrip()
    str=str.replace('@!','\t').rstrip()
    str=str + '\n'
    linelist.append(str)

#new a test file to save the result
if os.path.exists(('%s/test'%pwd)):
        os.system('rm test -f')

f1 = open('test','w')

for index in range(0,len(linelist)):
    f1.write(linelist[index])


f.close()
f1.close()

#change the on to off
#os.system('sed -i "s/ on / off /g" test')

#update the table file
os.system('cp test %s -f'%target)

os.system('rm test -f')

print("table remake success!")
