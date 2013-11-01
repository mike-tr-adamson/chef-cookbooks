#
# Cookbook Name:: virtualbox
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'Install virtualbox' do
  user 'root'
  group 'root'
  code <<-EOH
  apt-get -y install virtualbox-nonfree
  VBOX_VERSION=4.2.12
  wget -O /tmp/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack http://download.virtualbox.org/virtualbox/$VBOX_VERSION/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack
  VBoxManage extpack install /tmp/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack
  EOH
  not_if { ::File.exists?('/usr/bin/VBoxManage') }
end

node['users']['installed'].each do |user|
	group 'vboxusers' do
		append true
		members user
		action :modify
	end
end
