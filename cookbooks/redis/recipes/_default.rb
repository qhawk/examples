#
# Cookbook Name:: redis
# Recipe:: _default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Translated Instructions From:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis

execute "apt-get update"

package "build-essential"

package "tcl8.5"

remote_file "/root/redis-2.8.9.tar.gz" do
  source "http://download.redis.io/releases/redis-2.8.9.tar.gz"
  notifies :run, "execute[tar xzf redis-2.8.9.tar.gz]", :immediately
end

execute "tar xzf redis-2.8.9.tar.gz" do
  cwd "/root"
  action :nothing
  notifies :run, "execute[make && make install]", :immediately
end

execute "make && make install" do
  cwd "/root/redis-2.8.9"
  action :nothing
  notifies :run, "execute[echo -n | ./install_server.sh]", :immediately
end

#
# To install Redis without human-interaction
# and accepting all the defaults:
#
# https://realguess.net/2014/07/19/non-interactive-redis-install/

execute "echo -n | ./install_server.sh" do
  cwd "/root/redis-2.8.9/utils"
  action :nothing
end

service "redis_6379" do
  action [ :start ]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true
end