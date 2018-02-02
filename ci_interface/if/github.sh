#! /usr/bin/expect

spawn git push origin master

expect "Username for 'https://github.com':"

#uname='Luojiaxing1991'
#upwd='ljxfyjh1321'

send "Luojiaxing1991\r"

expect "Password for 'https://Luojiaxing1991@github.com':"

send "ljxfyjh1321\r"

expect eof

exit
