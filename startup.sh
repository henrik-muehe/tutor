#!/bin/bash

echo 	"cd /src ; \
		source /usr/local/rvm/scripts/rvm ;
		rvm use . ; \
		bundle install ; \
		bower install --allow-root; \
		rake db:migrate RAILS_ENV=production; 
		RAILS_ENV=production bundle exec rake assets:precompile ;
		rails server mongrel -p 8080 -e production; sleep 20;" > /src/sudoscript
rm -rf /src/tmp/
mkdir /src/tmp
chown -R user: /src
chown -R user: /usr/local/rvm/
chmod 755 /src/sudoscript

/usr/sbin/sshd &
#sudo -i -u user -- bash /src/sudoscript
script /tmp/script -c 'tmux new "cd /src ; sudo -i -u user -- bash /src/sudoscript"'
