#
# Cookbook Name:: memoryanalyser
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'Install MAT' do
  user 'root'
  group 'root'
  code <<-EOH
    unzip -q /data/file_repo/MemoryAnalyzer-1.3.0.20130517-linux.gtk.x86_64.zip -d /apps
    EOH
  not_if { ::File.exists?('/apps/mat') }
end

node['mat']['users'].each do |user|
	ruby_block "Set MAT path for user #{user}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set MAT path for user",
		  "\n# Set MAT path for user\nexport MAT_HOME=/apps/mat\nexport PATH=$MAT_HOME:$PATH"
		)
		file.write_file
	  end
	end	
end
