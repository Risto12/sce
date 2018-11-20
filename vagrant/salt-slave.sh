#!/bin/bash

apt update -qq >> /dev/null

apt install salt-minion -y >> /dev/null

echo -e "master: 192.168.1.112\nid: testing"|tee /etc/salt/minion

systemctl restart salt-minion.service



