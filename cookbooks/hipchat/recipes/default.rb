#
# Cookbook Name:: hipchat
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'Install hipchat' do
  user 'root'
  group 'root'
  code <<-EOH
  echo "deb http://downloads.hipchat.com/linux/apt stable main" > /etc/apt/sources.list.d/atlassian-hipchat.list
  wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -
  apt-get -y update
  apt-get -y install hipchat 
  EOH
  not_if { ::File.exists?('/etc/apt/sources.list.d/atlassian-hipchat.list') }
end

