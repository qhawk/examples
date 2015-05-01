#
# Cookbook Name:: php_on_apache
# Recipe:: _default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

execute 'apt-get update'

package 'apache2'

# PHP Packages

php_packages = %w(php5 libapache2-mod-php5 php5-mcrypt)

php_packages.each { |name| package name }

template '/etc/apache2/mods-enabled/dir.conf' do
  source 'dir.conf.erb'
end

#
# TODO: this would be the part where they would pull down the app
# with remote file, unpack it into the /var/www directory
#
cookbook_file '/var/www/index.php' do
  source 'index.php'
end

service 'apache2' do
  action [:enable, :start]
end
