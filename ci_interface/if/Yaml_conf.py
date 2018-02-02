#! /usr/bin/env python

class YConf:
    ci_format = "Lava-Test-Shell Test Definition 1.0"
    ci_os     = "ubuntu"
    ci_device = "rtsm_fvp_base-aemv8a"
    nor_maintainer = "luojiaxing@huawei.com"
    nor_scope = "functional"
    nor_env   = "lava-test-shell"
    nor_pattern = "(?P<test_case_id>[ /a-zA-Z0-9]+): (?P<result>[A-Z]+)"

def SetYConf(tmpFormat,tmpos,tmpdev):
        YConf.ci_format = tmpFormat
        YConf.ci_os     = tmpos
        YConf.ci_device = tmpdev
        
def getYConf():
     return YConf
