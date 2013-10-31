#
# Cookbook Name:: skype
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
dpkg_package "skype-ubuntu-precise_4.2.0.11-1_i386" do
	source "#{node['repo_dir']}/skype-ubuntu-precise_4.2.0.11-1_i386.deb"
	ignore_failure true
	action :install
end

bash 'Apt upgrade' do
  user 'root'
  group 'root'
  code <<-EOH
    apt-get -fy install
  EOH
end

