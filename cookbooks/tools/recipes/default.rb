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

node["tools"]["packages"].each do |package|
	package package
end

dpkg_package "vagrant" do
	source "/data/file_repo/vagrant_1.2.2_x86_64.deb"
	action :install
end

directory "/apps" do
  owner "root"
  group "users"
  mode 00774
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
  code <<-EOH
    mkdir -p /apps/jdk1.6.0.30
    tar xzf /data/file_repo/sun-jdk-linux-x86_64-1.6.0.30.tar.gz -C /apps/jdk1.6.0.30
    ln -s /apps/jdk1.6.0.30 /apps/jdk1.6
    EOH
  not_if { ::File.exists?('/apps/jdk1.6.0.30') }
end

bash 'Install Java 1.7' do
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
  code <<-EOH
    unzip /data/file_repo/gradle-1.6-all.zip -q -d /apps
    ln -s /apps/gradle-1.6 /apps/gradle
    EOH
  not_if { ::File.exists?('/apps/gradle-1.6') }
end

bash 'Install Ant' do
  code <<-EOH
    tar xzf /data/file_repo/apache-ant-1.9.1-bin.tar.gz -C /apps
    ln -s /apps/apache-ant-1.9.1 /apps/apache-ant
    EOH
  not_if { ::File.exists?('/apps/apache-ant-1.9.1') }
end

bash 'Install Maven' do
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

# Install eclipse
bash 'Install Eclipse' do
  code <<-EOH
    tar xzf /data/file_repo/eclipse-jee-kepler-R-linux-gtk-x86_64.tar.gz -C /apps
    mv /apps/eclipse /apps/eclipse-jee-kepler
    ln -s /apps/eclipse-jee-kepler /apps/eclipse
    EOH
  not_if { ::File.exists?('/apps/eclipse-jee-kepler') }
end

template "/apps/eclipse-jee-kepler/eclipse.ini" do
	source "eclipse.ini.erb"
end

users.each do |user|
	ruby_block "Set eclipse path for user #{user['name']}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user['name']}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set eclipse path for user",
		  "\n# Set eclipse path for user\nexport ECLIPSE_HOME=/apps/eclipse\nexport PATH=$ECLIPSE_HOME:$PATH"
		)
		file.write_file
	  end
	end	
end

# Install IntelliJ
bash 'Install IntelliJ' do
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
