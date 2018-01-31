#! /usr/bin/env python

import os

import sys

import pexpect

import time

import commands

import string

#get the current path,this path is no including the file name
pwd = os.path.split(os.path.realpath(__file__))[0]

os.chdir(pwd)

#get the CI test case repo
gitrepo = 'https://github.com/Luojiaxing1991/luo_driver_ci_testcase.git'

print(gitrepo.split("/")[-1][:-4])

#get the repo dir name when clone into current dir
RepoDir = gitrepo.split("/")[-1][:-4]

os.chdir('%s/ci_testcase'%RepoDir)

#we find out if the Repo is update within 30 minutes
#if so ,we need to update the CI
#if not,we do nothing 
tmpformate = '--pretty=format:%cd'
tmpres,loginfo = commands.getstatusoutput('git log remotes/origin/master  %s -1 --date=relative'%(tmpformate))
print(loginfo)
print(loginfo)

tmpvalue = string.atoi(loginfo.split(" ")[0])

tmpunit = loginfo.split(" ")[1]

if tmpunit == 'minutes':
    if tmpvalue > 30:
        print('Repo is not updated,Stop')
        sys.exit(0)
elif tmpunit != 'seconds':
    print('Repo is not updated,Stop')
    sys.exit(0)

print('Repo is updated,Keep running!')

#we get back to root to delete the old repo and download the new one
os.chdir(pwd)
os.system('rm -rf  %s'%RepoDir)

#git clone
os.system('git clone %s'%gitrepo)

#cd to the git/ci_testcase 
#os.system('cd %s/ci_testcase'%RepoDir)
os.chdir('%s/ci_testcase'%RepoDir)

print(os.getcwd())

os.system('python ci_interface/if/CI_if.py')

print(time.strftime('%Y-%m-%d',time.localtime(time.time())))

os.system('git commit -m \'ci test case new generate:%s\' '%time.strftime('%Y-%m-%d',time.localtime(time.time())))

os.system('expect ci_interface/if/github.sh')

os.chdir(pwd)



