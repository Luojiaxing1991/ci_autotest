#! /usr/bin/env python

import os

import sys

#we should first import the path of ci_interface/if


#gpus = sys.argv[1]
#batch_size = sys.argv[2]

#print gpus
#print batch_size

#This function get the dir name in curr dir
#return: the name list of dir name
def get_dir_name(file_dir):
    for root,dirs,files in os.walk(file_dir):
        #we need to get the dirlist in current document
        if root==file_dir:
            return dirs

    return none

#get the path which place the  module test case 
pwd = '%s/../../'%os.path.split(os.path.realpath(__file__))[0]

#get the dir name list
dirlist = get_dir_name(pwd)

#output the dir name for debug
print(dirlist)

#new a list used to save the ci dir among the dir name before
cidir = []

#we find the dir according to keyword,
#the key word used to place in last of dirname
keyword = 'autotest'

for i in range(len(dirlist)):
    if dirlist[i][-len(keyword):] == keyword:
        cidir.append(dirlist[i])

#output the ci dir name
print(cidir)


for targetdir in cidir:
    currdir = '%s/%s'%(pwd,targetdir)

    print(currdir)


    #Yaml_generate.py have two input para:
    #1.workspace path 2.current path
    os.system("python %s/Yaml_generate.py %s %s"%(os.path.split(os.path.realpath(__file__))[0],currdir,pwd))

