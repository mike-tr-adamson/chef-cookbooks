#
# Cookbook Name:: vagrant
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
dpkg_package "vagrant_1.2.2_x86_64" do
	source "#{node['repo_dir']}/vagrant_1.2.2_x86_64.deb"
	ignore_failure true
	action :install
end

