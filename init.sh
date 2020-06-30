#!/bin/bash
echo "{“health”: “ok”}" | sudo tee /etc/nginx/index.html
echo "server { listen 8080; location /health { index /etc/nginx/index.html; } }" | sudo tee /etc/nginx/nginx.conf
echo "package { "nginx": \
        ensure => present, \
        } \
        service { "nginx": \
            ensure => "running", \
            enable => true, \
            require => Package["nginx"], \
        } \
        " | sudo tee manifest.pp
sudo apt-get update && sudo apt-get install ruby -y
sudo gem install --no-document puppet
sudo puppet apply manifest.pp
