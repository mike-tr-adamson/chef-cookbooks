#
# Cookbook Name:: subversion
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
encrypted_users = data_bag('users')

users = []

encrypted_users.each do |encrypted_user|
	user = Chef::EncryptedDataBagItem.load("users", encrypted_user)
	if node['subversion']['users'].include?(user['name'])
		users << user
	end
end

users.each do |user|
	directory "/home/#{user['name']}/.subversion" do
		owner "#{user['name']}"
		group 'users'
	end
	template "/home/#{user['name']}/.subversion/config" do
		source "subversion_config.erb"
		owner user['uid']
		group 1001
		mode "0600"
	end
end
