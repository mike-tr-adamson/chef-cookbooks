#
# Cookbook Name:: visualvm
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'Install VisualVM' do
  user 'root'
  group 'root'
  code <<-EOH
    unzip -q #{node['repo_dir']}/visualvm_136.zip -d /apps
    ln -s /apps/visualvm_136 /apps/visualvm
    EOH
  not_if { ::File.exists?('/apps/visualvm_136') }
end

node['visualvm']['users'].each do |user|
	ruby_block "Set visualvm path for user #{user}" do
	  block do
		file = Chef::Util::FileEdit.new("/home/#{user}/.bashrc")
		file.insert_line_if_no_match(
		  "# Set visualvm tool path for user",
		  "\n# Set visualvm tool path for user\nexport VISUALVM_HOME=/apps/visualvm\nexport PATH=$VISUALVM_HOME/bin:$PATH"
		)
		file.write_file
	  end
	end	
end

