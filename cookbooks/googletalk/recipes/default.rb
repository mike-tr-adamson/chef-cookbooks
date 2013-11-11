#
# Cookbook Name:: googletalk
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
dpkg_package "google-talkplugin-current_amd64" do
	source "#{node['repo_dir']}/google-talkplugin_current_amd64.deb"
	ignore_failure true
	action :install
end

