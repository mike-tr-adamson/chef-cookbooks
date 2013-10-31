#
# Cookbook Name:: ant
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'Install Ant' do
  user 'root'
  group 'root'
  code <<-EOH
    tar xzf #{node['repo_dir']}/apache-ant-1.9.1-bin.tar.gz -C /apps
    ln -s /apps/apache-ant-1.9.1 /apps/apache-ant
    EOH
  not_if { ::File.exists?('/apps/apache-ant-1.9.1') }
end

node['ant']['users'].each do |user|
	ruby_block "Set ant path for user #{user}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set ant tool path for user",
		  "\n# Set ant tool path for user\nexport ANT_HOME=/apps/apache-ant\nexport PATH=$ANT_HOME/bin:$PATH"
		)
		file.write_file
	  end
	end	
end

