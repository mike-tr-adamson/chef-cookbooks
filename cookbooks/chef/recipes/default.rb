#
# Cookbook Name:: chef
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
node['chef']['users'].each do |user|
	directory "/home/#{user}/.chef" do
		owner "#{user}"
		group 'users'
	end
	bash "Copy knife files for #{user}" do
		user "#{user}"
		group 'users'
		code <<-EOH
			cp /data/file_repo/knife.rb /home/#{user}/.chef
			cp /data/file_repo/mike_tr_adamson.pem /home/#{user}/.chef
			cp /data/file_repo/mike_tr_adamson-validator.pem /home/#{user}/.chef
		EOH
		not_if { ::File.exists?("/home/#{user}/.chef/knife.rb") }
	end
end
