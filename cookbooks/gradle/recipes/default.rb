#
# Cookbook Name:: gradle
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'Install Gradle' do
  user 'root'
  group 'root'
  code <<-EOH
    unzip -q #{node['repo_dir']}/gradle-1.8-all.zip -d /apps
    ln -s /apps/gradle-1.8 /apps/gradle
    EOH
  not_if { ::File.exists?('/apps/gradle-1.8') }
end

node['gradle']['users'].each do |user|
	ruby_block "Set gradle path for user #{user}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set gradle tool path for user",
		  "\n# Set gradle tool path for user\nexport GRADLE_HOME=/apps/gradle\nexport PATH=$GRADLE_HOME/bin:$PATH"
		)
		file.write_file
	  end
	end	
end

