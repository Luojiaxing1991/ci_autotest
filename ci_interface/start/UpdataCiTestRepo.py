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
gitrepo = 'https://github.com/Luojiaxing1991/ci_autotest.git'

print(gitrepo.split("/")[-1][:-4])

#get the repo dir name when clone into current dir
RepoDir = gitrepo.split("/")[-1][:-4]

os.chdir(RepoDir)

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

#os.system('cp -rf %s/%s/ci_interface/if/gitclone.sh gitclone.sh'%(pwd,RepoDir))

os.system('rm -rf  %s'%RepoDir)

#git clone
#os.system('expect gitclone.sh %s'%gitrepo)
os.system('git clone %s'%gitrepo)
#os.system('rm -fr gitclone.sh')

#cd to the git/ci_testcase 
os.chdir(RepoDir)

print(os.getcwd())

os.system('python ci_interface/if/CI_if.py')

print(time.strftime('%Y-%m-%d',time.localtime(time.time())))

os.system('git commit -m \'ci test case new generate:%s\' '%time.strftime('%Y-%m-%d',time.localtime(time.time())))

os.system('expect ci_interface/if/github.sh')

os.chdir(pwd)



