#
# Cookbook Name:: eclipse
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#
secret = Chef::EncryptedDataBagItem.load_secret("#{node[:chef_secret_path]}")
encrypted_users = data_bag('users')
users = []
encrypted_users.each do |encrypted_user|
	users << Chef::EncryptedDataBagItem.load("users", encrypted_user, secret)
end

bash 'Install Eclipse' do
  user 'root'
  group 'root'
  code <<-EOH
    tar --no-same-owner --no-same-permissions -xzf /data/file_repo/eclipse-jee-kepler-R-linux-gtk-x86_64.tar.gz -C /apps
    mv /apps/eclipse /apps/eclipse-jee-kepler
    ln -s /apps/eclipse-jee-kepler /apps/eclipse
    EOH
  not_if { ::File.exists?('/apps/eclipse-jee-kepler') }
end

template "/apps/eclipse-jee-kepler/eclipse.ini" do
	source "eclipse.ini.erb"
end

directory "/apps/eclipse-jee-kepler/dropins/subclipse" do
end

bash 'Install Subclipse plugin' do
  user 'root'
  group 'root'
  code <<-EOH
    unzip -q /data/file_repo/subclipse-1.6.18.zip -d /apps/eclipse-jee-kepler/dropins/subclipse
    EOH
  not_if { ::File.exists?('/apps/eclipse-jee-kepler/dropins/subclipse/artifacts.xml') }
end

directory "/apps/eclipse-jee-kepler/dropins/mat" do
end

#bash 'Install Memory Analyser plugin' do
#  user 'root'
#  group 'root'
#  code <<-EOH
#    unzip -q /data/file_repo/MemoryAnalyzer-1.3.0.201305170842.zip -d /apps/eclipse-jee-kepler/dropins/mat
#    EOH
#  not_if { ::File.exists?('/apps/eclipse-jee-kepler/dropins/mat/site.xml') }
#end

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
