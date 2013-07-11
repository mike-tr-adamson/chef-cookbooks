#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'Install mysql server' do
  user 'root'
  group 'root'
  code <<-EOH
  debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password password'
  debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password password'
  apt-get -y install mysql-server	
  EOH
  not_if { ::File.exists?('/etc/init.d/mysql') }
end
