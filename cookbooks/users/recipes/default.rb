#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#
group "users" do
	gid 1001
end

template "/etc/sudoers.d/users" do
	source "sudoers.erb"
end

template "/etc/pam.d/sshd" do
	source "pamd_ssh.erb"
end

secret = Chef::EncryptedDataBagItem.load_secret("#{node[:chef_secret_path]}")

encrypted_users = data_bag('users')

users = []
ssh_keys = []

encrypted_users.each do |encrypted_user|
	user = Chef::EncryptedDataBagItem.load("users", encrypted_user, secret)
	users << user
	ssh_keys << user['ssh_public_key']
end

users.each do |user|
	home_dir = "/home/#{user['name']}"
	user(user['name']) do
		uid			user['uid']
		gid			1001
		password	user['password']
		comment		user['comment']
		shell		'/bin/bash'
		home		home_dir
		supports	:manage_home => true
	end
	ssh_dir = "#{home_dir}/.ssh"
	if not File.exist?(ssh_dir)
		directory ssh_dir do
			owner user['uid']
			group 1001
			mode "0700"
		end
	end
	template "#{ssh_dir}/authorized_keys" do
		source "authorized_keys.erb"
		owner user['uid']
		group 1001
		mode "0600"
		variables :ssh_keys => ssh_keys
	end

	template "#{ssh_dir}/id_rsa.pub" do
		source "rsa_public_key.erb"
		owner user['uid']
		group 1001
		mode "0400"
		variables :public_key => user['ssh_public_key']
	end
	template "#{ssh_dir}/id_rsa" do
		source "rsa_private_key.erb"
		owner user['uid']
		group 1001
		mode "0400"
		variables :private_key => user['ssh_private_key']
	end
	template "#{home_dir}/.bashrc" do
		source "bashrc.erb"
		owner user['uid']
		group 1001
		mode "0400"
		variables :bash_aliases => user['bash_aliases']
	end
	template "#{home_dir}/.bash_profile" do
		source "bash_profile.erb"
		owner user['uid']
		group 1001
		mode "0400"
	end
end
