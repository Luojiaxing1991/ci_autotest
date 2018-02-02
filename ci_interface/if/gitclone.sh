#! /usr/bin/expect

#para [1] the repo addr which want to clone.

set gitaddr [lindex $argv 0]

spawn git clone $gitaddr

expect "Username for 'https://github.com':"

#uname='Luojiaxing1991'
#upwd='ljxfyjh1321'

send "Luojiaxing1991\r"

expect "Password for 'https://Luojiaxing1991@github.com':"

send "ljxfyjh1321\r"

expect eof

exit
