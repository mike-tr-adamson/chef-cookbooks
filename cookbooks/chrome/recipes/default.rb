#
# Cookbook Name:: chrome
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
dpkg_package "google-chrome-stable_current_amd64" do
	source "#{node['repo_dir']}/google-chrome-stable_current_amd64.deb"
	ignore_failure true
	action :install
end

