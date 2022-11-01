#!/bin/bash

rm -rf /home/student/testlog /home/student/.ssh/known_hosts


mkdir /home/student/testlog
rsync -av root@server2:/var/log ~/testlog && logger -p user.notice "Log files synchronized"

ssh server2 mkdir /tmp/config


scp root@server2:/tmp/config.tar.bz2 /tmp/
