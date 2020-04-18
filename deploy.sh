#!/bin/sh

ssh rails@qnow.app <<'ENDSSH'
cd ~/qnow
git checkout master
git pull origin master
git checkout -b production
RAILS_ENV=production rake assets:precompile
bin/webpack
touch tmp/restart.txt
ENDSSH
