#
# Cookbook Name:: openswan
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'Install openswan' do
  user 'root'
  group 'root'
  code <<-EOH
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --force-yes openswan
  apt-get -y install xl2tpd
  EOH
  not_if { ::File.exists?('/etc/init.d/ipsec') }
end

