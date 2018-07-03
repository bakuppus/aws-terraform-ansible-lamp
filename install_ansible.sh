#!/bin/bash

ps -ef | grep -i yum

sudo  yum install python-pip  -y 

sudo pip install ansible
