#
# Cookbook Name:: mcs_oracle_prereq
# Recipe:: default
#
# Copyright 2013, BSkyB
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

node["oracle"]["db_packages"].each do |db_package|
  package db_package
end

user "oracle" do
  comment "Oracle Service Account - DBA"
  home "/home/oracle"
  shell "/bin/bash"
  password "$6$b9rBEbu/$B5iPMdUF1hVaP5EcRGJc2vXqtgj9zsQxamGXTibZNUUoLPfFhVlXZtj0Fubi35sbgXXUR5wS5Tb5H1P6reVax."
  ignore_failure true
  supports :manage_home => true
end

group "oinstall" do
  members "oracle"
end

group "dba" do
  members "oracle"
end

group "oper" do
  members "oracle"
end

group "asmadmin" do
  members "oracle"
end

directory "/u01/app/oracle/product/11.2.0/db_1" do
  owner "oracle"
  group "oinstall"
  mode "775"
  recursive true
end

directory "/u01/app/oraInventory" do
  owner "oracle"
  group "oinstall"
  mode "775"
  recursive true
end

directory "/home/oracle/.ssh" do
  owner "oracle"
  group "root"
  mode "700"
end

template "/home/oracle/.ssh/authorized_keys" do
	source "authorized_keys.erb"
	owner "oracle"
	group "root"
	mode "0600"
	variables :ssh_keys => ssh_keys
end

file "/etc/sudoers.d/oracle" do
  owner "root"
  group "root"
  mode "440"
  content <<-EOH
oracle        ALL=(ALL)       NOPASSWD: ALL
  EOH
end

file "/home/oracle/.bash_profile" do
  owner "oracle"
  group "oracle"
  content <<-EOH
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# Oracle Settings
TMP=/tmp; export TMP
TMPDIR=\$TMP; export TMPDIR

ORACLE_HOSTNAME=mcsbuild; export ORACLE_HOSTNAME
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/db_1; export ORACLE_HOME
ORACLE_SID=MCS11G; export ORACLE_SID
ORACLE_TERM=xterm; export ORACLE_TERM
ORAENV_ASK=NO; export ORAENV_ASK
PATH=/usr/sbin:\$PATH; export PATH
PATH=\$ORACLE_HOME/bin:\$PATH; export PATH

LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=\$ORACLE_HOME/JRE:\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib; export CLASSPATH
  EOH
end



bash "Set Oracle Directory Permissions" do
  user "root"
  code <<-EOH
  chown -R oracle:oinstall /u01
  chmod -R 0775 /u01
  EOH
end

template "/etc/security/limits.d/oracle.conf" do
  owner "root"
  group "root"
  mode "0644"
  source "oracle-limits.conf.erb"
end

cookbook_file "/home/oracle/oracle_install.sh" do
  source "oracle_install.sh"
  mode 0755
  owner "oracle"
  group "oracle"
end

cookbook_file "/home/oracle/db.rsp" do
  source "db.rsp"
  mode 0644
  owner "oracle"
  group "oracle"
end

cookbook_file "/root/oracle_root_install.sh" do
  source "oracle_root_install.sh"
  mode 0755
  owner "root"
  group "root"
end

cookbook_file "/home/oracle/create_ccs_tbs.sql" do
  source "create_ccs_tbs.sql"
  mode 0644
  owner "oracle"
  group "oracle"
end

cookbook_file "/root/oracle" do
  source "oracle"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/root/oratab" do
  source "oratab"
  mode 0755
  owner "root"
  group "root"
end

include_recipe "el-sysctl"
