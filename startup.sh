#!/bin/bash

source /usr/local/rvm/scripts/rvm
cd /src ; rvm use .
cd /src ; bundle install
cd /src ; bower install --allow-root
chown -R user: /src
script /tmp/script -c 'tmux new -d "cd /src ; sudo -u user -- rails server mongrel -p 8080 -e production"'
/usr/sbin/sshd -D
