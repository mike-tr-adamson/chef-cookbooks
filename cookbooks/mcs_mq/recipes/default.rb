#
# Cookbook Name:: mcs_mq
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#
secret = Chef::EncryptedDataBagItem.load_secret("#{node[:chef_secret_path]}")
encrypted_users = data_bag('users')
ssh_keys = []

encrypted_users.each do |encrypted_user|
	user = Chef::EncryptedDataBagItem.load("users", encrypted_user, secret)
	ssh_keys << user['ssh_public_key']
end

node["mq"]["i686_packages"].each do |package|
  yum_package package do
	arch "i686"
  end
end

bash "Accept MQ License" do
  user "root"
  code <<-EOH
/vagrant/mq/CZ4VEML/mqlicense.sh -accept  
  EOH
end

node["mq"]["v7_packages"].each do |package|
  rpm_package "/vagrant/mq/CZ4VEML/#{package}" do
	options "-iv"
  end
end

node["mq"]["v71_replacement_packages"].each do |package|
  rpm_package "/vagrant/mq/7.0.1.7/#{package}" do
	options "--nodeps --replacefiles -ivh"
  end
end

node["mq"]["v71_packages"].each do |package|
  rpm_package "/vagrant/mq/7.0.1.7/#{package}" do
	options "--nodeps -ivh"
  end
end

directory "/var/mqm/.ssh" do
  owner "mqm"
  group "root"
  mode "700"
end

template "/var/mqm/.ssh/authorized_keys" do
	source "authorized_keys.erb"
	owner "mqm"
	group "root"
	mode "0600"
	variables :ssh_keys => ssh_keys
end

file "/etc/ssh/sshd_config" do
  owner "root"
  group "root"
  mode "600"
  content <<-EOH
Protocol 2
SyslogFacility AUTHPRIV
StrictModes no
PasswordAuthentication yes
ChallengeResponseAuthentication no
GSSAPIAuthentication yes
GSSAPICleanupCredentials yes
UsePAM yes
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
X11Forwarding yes
Subsystem       sftp    /usr/libexec/openssh/sftp-server
  EOH
end

