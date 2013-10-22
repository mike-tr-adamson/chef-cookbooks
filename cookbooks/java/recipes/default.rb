#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#
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

node['users']['installed'].each do |user|
	ruby_block "Set JAVA_HOME for user #{user}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user}/.bashrc")
        version = node['java']["#{user}"]
		file.insert_line_if_no_match(
		  "# Set JAVA_HOME for user",
		  "\n# Set JAVA_HOME for user\nexport JAVA_HOME=/apps/jdk#{version}\nexport PATH=$JAVA_HOME/bin:$PATH"
		)
		file.write_file
	  end
	end	
end
