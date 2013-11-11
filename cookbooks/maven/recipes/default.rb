#
# Cookbook Name:: maven
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'Install Maven' do
  user 'root'
  group 'root'
  code <<-EOH
    tar xzf #{node['repo_dir']}/apache-maven-3.0.5-bin.tar.gz -C /apps
    ln -s /apps/apache-maven-3.0.5 /apps/apache-maven
    EOH
  not_if { ::File.exists?('/apps/apache-maven-3.0.5') }
end

node['maven']['users'].each do |user|
	ruby_block "Set maven path for user #{user}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set maven tool path for user",
		  "\n# Set maven tool path for user\nexport M2_HOME=/apps/apache-maven\nexport PATH=$M2_HOME/bin:$PATH"
		)
		file.write_file
	  end
	end	
end

