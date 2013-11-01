#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#
require 'base64'

group "users" do
	gid 1001
end

template "/etc/sudoers.d/users" do
	source "sudoers.erb"
end

template "/etc/pam.d/sshd" do
	source "pamd_ssh.erb"
end

encrypted_users = data_bag('users')

users = []
ssh_keys = []

encrypted_users.each do |encrypted_user|
	user = Chef::EncryptedDataBagItem.load("users", encrypted_user)
	if node['users']['installed'].include?(user['name'])
		users << user
		ssh_keys << user['ssh_public_key']
	end
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
	node['additional_groups'].each do |additional_group|
		group additional_group do
			append true
			members user['name']
			action :modify
		end
	end
	ssh_dir = "#{home_dir}/.ssh"
	directory "#{home_dir}/.ssh" do
		owner user['uid']
		group 1001
		mode "0700"
	end
	directory "#{home_dir}/.keys" do
		owner user['uid']
		group 1001
		mode "0700"
	end
	directory "#{home_dir}/bin" do
		owner user['uid']
		group 1001
		mode "0700"
	end
	directory "/data" do
		owner "root"
		group "root"
	end
	directory "/data/userdata" do
		owner "root"
        group 1001
    end
	directory "/data/downloads" do
		owner "root"
        group 1001
    end
	directory "/data/securedata" do
		owner "root"
        group 1001
    end
	directory "/data/userdata/documents" do
		owner "root"
        group 1001
    end
	directory "/data/userdata/music" do
		owner "root"
        group 1001
    end
	directory "/data/userdata/pictures" do
		owner "root"
        group 1001
    end
	directory "/data/userdata/videos" do
		owner "root"
        group 1001
    end
	directory "/data/userdata/workspaces" do
		owner "root"
        group 1001
    end
	directory "/data/userdata/vms" do
		owner "root"
        group 1001
    end
    directory "/data/userdata/documents/#{user['name']}" do
		owner user['uid']
		group 1001
    end
    directory "/data/userdata/music/#{user['name']}" do
		owner user['uid']
		group 1001
    end
    directory "/data/userdata/pictures/#{user['name']}" do
		owner user['uid']
		group 1001
    end
    directory "/data/userdata/videos/#{user['name']}" do
		owner user['uid']
		group 1001
    end
    directory "/data/userdata/workspaces/#{user['name']}" do
		owner user['uid']
		group 1001
    end
    directory "/data/userdata/vms/#{user['name']}" do
		owner user['uid']
		group 1001
    end
	template "#{home_dir}/.ssh/authorized_keys" do
		source "authorized_keys.erb"
		owner user['uid']
		group 1001
		mode "0600"
		variables :ssh_keys => ssh_keys
	end
	template "#{home_dir}/.ssh/id_rsa.pub" do
		source "rsa_public_key.erb"
		owner user['uid']
		group 1001
		mode "0400"
		variables :public_key => user['ssh_public_key']
	end
	template "#{home_dir}/.ssh/id_rsa" do
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
    unless user['client_key'].nil? 
		file "#{home_dir}/.keys/client.p12" do
			content Base64.decode64(user['client_key'])
			owner user['uid']
			group 1001
			mode "0400"
			action :create
		end
	end
    unless user['trust_key'].nil? 
		file "#{home_dir}/.keys/trust.jks" do
			content Base64.decode64(user['trust_key'])
			owner user['uid']
			group 1001
			mode "0400"
			action :create
		end
	end
    unless user['authority_key'].nil? 
		file "#{home_dir}/.keys/authority.pem" do
			content Base64.decode64(user['authority_key'])
			owner user['uid']
			group 1001
			mode "0400"
			action :create
		end
	end

	directory "#{home_dir}/Documents" do
		action :delete
		not_if "test -L #{home_dir}/Documents"
	end
	link "#{home_dir}/Documents" do
		owner user['uid']
		group 1001
		to "/data/userdata/documents/#{user['name']}"
		not_if "test -L #{home_dir}/Documents"
	end
	directory "#{home_dir}/Downloads" do
		action :delete
		not_if "test -L #{home_dir}/Downloads"
	end
	link "#{home_dir}/Downloads" do
		owner user['uid']
		group 1001
		to "/data/downloads"
		not_if "test -L #{home_dir}/Downloads"
	end
	directory "#{home_dir}/Music" do
		action :delete
		not_if "test -L #{home_dir}/Music"
	end
	link "#{home_dir}/Music" do
		owner user['uid']
		group 1001
		to "/data/userdata/music/#{user['name']}"
		not_if "test -L #{home_dir}/Music"
	end
	directory "#{home_dir}/Pictures" do
		action :delete
		not_if "test -L #{home_dir}/Pictures"
	end
	link "#{home_dir}/Pictures" do
		owner user['uid']
		group 1001
		to "/data/userdata/pictures/#{user['name']}"
		not_if "test -L #{home_dir}/Pictures"
	end
	directory "#{home_dir}/Videos" do
		action :delete
		not_if "test -L #{home_dir}/Videos"
	end
	link "#{home_dir}/Videos" do
		owner user['uid']
		group 1001
		to "/data/userdata/videos/#{user['name']}"
		not_if "test -L #{home_dir}/Videos"
	end
	link "#{home_dir}/workspaces" do
		owner user['uid']
		group 1001
		to "/data/userdata/workspaces/#{user['name']}"
		not_if "test -L #{home_dir}/workspaces"
	end
	link "#{home_dir}/VirtualBox VMs" do
		owner user['uid']
		group 1001
		to "/data/userdata/vms/#{user['name']}"
		not_if "test -L #{home_dir}/vms"
	end
end
