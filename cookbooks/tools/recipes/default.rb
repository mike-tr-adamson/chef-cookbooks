#
# Cookbook Name:: tools
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#

# Load the users so we can add to their path as tools are loaded
secret = Chef::EncryptedDataBagItem.load_secret("#{node[:chef_secret_path]}")
encrypted_users = data_bag('users')
users = []
encrypted_users.each do |encrypted_user|
	users << Chef::EncryptedDataBagItem.load("users", encrypted_user, secret)
end

#bash 'Install xorg-edgy' do
#  user 'root'
#  group 'root'
#  code <<-EOH
#  add-apt-repository ppa:xorg-edgers/ppa
#  apt-get update
#  EOH
#end


node["tools"]["packages"].each do |package|
	package package
end

node["tools"]["deb_packages"].each do |package|
	dpkg_package package do
		source "/data/file_repo/#{package}.deb"
		ignore_failure true
		action :install
	end
end

node["tools"]["scripts"].each do |script|
	bash "Copying script #{script}" do
		user 'root'
		group 'users'
		umask '007'
		code <<-EOH
			cp /data/file_repo/#{script} /apps/bin
		EOH
		not_if { ::File.exists?("/apps/bin/#{script}") }
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

directory "/apps" do
  owner "root"
  group "root"
  mode 00775
  action :create
end

# Add /apps/bin to user path
directory "/apps/bin" do
  owner "root"
  group "users"
  mode 00774
  action :create
end

users.each do |user|
	ruby_block "add /apps/bin to path" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user['name']}/.bashrc")
		file.insert_line_if_no_match(
		  "# Add common bin to path",
		  "\n# Add common bin to path\nexport PATH=/apps/bin:$PATH"
		)
		file.write_file
	  end
	end	
end

# Install Java 1.6 & 1.7
bash 'Install Java 1.6' do
  user 'root'
  group 'root'
  code <<-EOH
    mkdir -p /apps/jdk1.6.0.30
    tar xzf /data/file_repo/sun-jdk-linux-x86_64-1.6.0.30.tar.gz -C /apps/jdk1.6.0.30
    ln -s /apps/jdk1.6.0.30 /apps/jdk1.6
    EOH
  not_if { ::File.exists?('/apps/jdk1.6.0.30') }
end

bash 'Install Java 1.7' do
  user 'root'
  group 'root'
  code <<-EOH
    mkdir -p /apps/jdk1.7.0.09
    tar xzf /data/file_repo/sun-jdk-linux-x86_64-1.7.0.09.tar.gz -C /apps/jdk1.7.0.09
    ln -s /apps/jdk1.7.0.09 /apps/jdk1.7
    EOH
  not_if { ::File.exists?('/apps/jdk1.7.0.09') }
end

users.each do |user|
	ruby_block "Set JAVA_HOME for user #{user['name']}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user['name']}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set JAVA_HOME for user",
		  "\n# Set JAVA_HOME for user\nexport JAVA_HOME=/apps/jdk#{user['java_version']}\nexport PATH=$JAVA_HOME/bin:$PATH"
		)
		file.write_file
	  end
	end	
end

# Install build tools
bash 'Install Gradle' do
  user 'root'
  group 'root'
  code <<-EOH
    unzip -q /data/file_repo/gradle-1.6-all.zip -d /apps
    ln -s /apps/gradle-1.6 /apps/gradle
    EOH
  not_if { ::File.exists?('/apps/gradle-1.6') }
end

bash 'Install Ant' do
  user 'root'
  group 'root'
  code <<-EOH
    tar xzf /data/file_repo/apache-ant-1.9.1-bin.tar.gz -C /apps
    ln -s /apps/apache-ant-1.9.1 /apps/apache-ant
    EOH
  not_if { ::File.exists?('/apps/apache-ant-1.9.1') }
end

bash 'Install Maven' do
  user 'root'
  group 'root'
  code <<-EOH
    tar xzf /data/file_repo/apache-maven-3.0.5-bin.tar.gz -C /apps
    ln -s /apps/apache-maven-3.0.5 /apps/apache-maven
    EOH
  not_if { ::File.exists?('/apps/apache-maven-3.0.5') }
end

users.each do |user|
	ruby_block "Set build tool paths for user #{user['name']}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user['name']}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set build tool paths for user",
		  "\n# Set build tool paths for user\nexport M2_HOME=/apps/apache-maven\nexport GRADLE_HOME=/apps/gradle\nexport ANT_HOME=/apps/apache-ant\nexport PATH=$GRADLE_HOME/bin:$ANT_HOME/bin:$M2_HOME/bin:$PATH"
		)
		file.write_file
	  end
	end	
end

# Install IntelliJ
bash 'Install IntelliJ' do
  user 'root'
  group 'root'
  code <<-EOH
    tar xzf /data/file_repo/ideaIU-12.1.4.tar.gz -C /apps
    ln -s /apps/idea-IU-129.713 /apps/intellij
    EOH
  not_if { ::File.exists?('/apps/idea-IU-129.713') }
end

users.each do |user|
	ruby_block "Set intellij path for user #{user['name']}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user['name']}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set intellij path for user",
		  "\n# Set intellij path for user\nexport INTELLIJ_HOME=/apps/intellij\nexport PATH=$INTELLIJ_HOME/bin:$PATH"
		)
		file.write_file
	  end
	end	
	directory "/home/#{user['name']}/.IntelliJIdea12" do
		owner "#{user['name']}"
		group 'users'
	end
	directory "/home/#{user['name']}/.IntelliJIdea12/config" do
		owner "#{user['name']}"
		group 'users'
	end
	bash "Install Intellij license key for #{user['name']}" do
		user "#{user['name']}"
		group 'users'
		code <<-EOH
		echo #{user['intellij_license']} | base64 -d - > /home/#{user['name']}/.IntelliJIdea12/config/idea12.key
		EOH
	end
end

bash 'Install SqlDeveloper' do
  user 'root'
  group 'root'
  code <<-EOH
    tar xzf /data/file_repo/sqldeveloper.tar.gz -C /apps
    EOH
  not_if { ::File.exists?('/apps/sqldeveloper') }
end

users.each do |user|
	ruby_block "Set sqldeveloper path for user #{user['name']}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user['name']}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set sqldeveloper path for user",
		  "\n# Set sqldeveloper path for user\nexport SQLDEV_HOME=/apps/sqldeveloper\nexport PATH=$SQLDEV_HOME:$PATH"
		)
		file.write_file
	  end
	end	
end

gem_package "vmc" do
  action :install
end

gem_package "nimbus" do
  source "/data/file_repo/nimbus-0.0.6.dev.gem"
  action :install
  ignore_failure true
end

# Add any other user specific changes
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
	directory "/home/#{user['name']}/.chef" do
		owner "#{user['name']}"
		group 'users'
	end
	bash "Copy knife files for #{user['name']}" do
		user "#{user['name']}"
		group 'users'
		code <<-EOH
			cp /data/file_repo/knife.rb /home/#{user['name']}/.chef
			cp /data/file_repo/mike_tr_adamson.pem /home/#{user['name']}/.chef
			cp /data/file_repo/mike_tr_adamson-validator.pem /home/#{user['name']}/.chef
		EOH
		not_if { ::File.exists?("/home/#{user['name']}/.chef/knife.rb") }
	end
	
end



