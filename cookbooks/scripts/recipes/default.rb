#
# Cookbook Name:: scripts
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#
node['users']['installed'].each do |user|
	bin_dir = "/home/#{user}/bin"
    node['scripts']["#{user}"].each do |script|
		bash "Copying script #{script} to user #{user}" do
			user 'root'
			group 'users'
			umask '007'
			code <<-EOH
				cp #{node['repo_dir']}/scripts/#{script} #{bin_dir}
			EOH
			not_if { ::File.exists?("#{bin_dir}/#{script}") }
		end
	end
end
