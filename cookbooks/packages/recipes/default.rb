#
# Cookbook Name:: packages
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#
node["packages"]["apps"].each do |app|
	package app
end

node["packages"]["debs"].each do |deb|
	dpkg_package deb do
		source "#{node['repo_dir']}/data/file_repo/#{deb}.deb"
		ignore_failure true
		action :install
	end
end

bash 'Apt upgrade' do
  user 'root'
  group 'root'
  code <<-EOH
    apt-get -fy install
    apt-get -y update
    apt-get -y upgrade
  EOH
end


