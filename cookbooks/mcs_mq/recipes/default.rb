#
# Cookbook Name:: mcs_mq
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#
node["mq"]["i686_packages"].each do |package|
  yum_package package do
	arch "i686"
  end
end

bash "Accept MQ License" do
  user "root"
  code <<-EOH
/vagrant/mq/CZ4VEML/mqlicense.sh -accept  
  EOH
end

node["mq"]["v7_packages"].each do |package|
  rpm_package "/vagrant/mq/CZ4VEML/#{package}" do
	options "-iv"
  end
end

node["mq"]["v71_replacement_packages"].each do |package|
  rpm_package "/vagrant/mq/7.0.1.7/#{package}" do
	options "--nodeps --replacefiles -ivh"
  end
end

node["mq"]["v71_packages"].each do |package|
  rpm_package "/vagrant/mq/7.0.1.7/#{package}" do
	options "--nodeps -ivh"
  end
end

directory "/var/mqm/.ssh" do
  owner "mqm"
  group "root"
  mode "700"
end

file "/var/mqm/.ssh/authorized_keys" do
  owner "mqm"
  group "root"
  mode "600"
  content <<-EOH
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDj4ARTohnnird3voY+PtwDmhTHEEPP2TXAFg0J1H/kNqIqnLXwEK5klDuebvBeUy684FfGFU7Wkfw4psdE/yXCQl5+vIdfhtow/WlZo5VqTkhBX+0VonSQiihXKfZ6wXL9nqnRyEXy75PfpRHxBdSZ4iXPSBMtAlT5ccCu2sR20AwmuMUKfP/s4ljIrZZmYTh8HRT9ZaeoGgEmyYDwnWUOPdW5H4RAu8R8MpXO2+9uC7CPdvB+TNL4EOnavAKn3SIUlf4J3NWXaOrpPWHqV/ZTW7zXIYGBuyyQ2h+2a3GSN2EF2b/LI7g5l8rQx/j3B4IRkr0xnz0TI4Mh2qk60v0v bskyb@localhost.localdomain
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwUcXuvzWs6cJgH3loHHuNAgsn0zyCkZ5/pIVc1iiQLpVzrACXzvUjaB25ahOv3K96ROYj8pr+qJ0MSEK83zKyGeMshkbIUomeOPiAiWwOjRoAaDlrp3nBb8tn2l9vxBPULML1iMT4jrn8bN37ru2eTk4b+qUVAgqEslUwKS2UJxjbOtUDMthOYKmVekk8ij3QHk3s/Wz/xNsuB3UHn3zo/Lpf9okZWN9nXvVQFzn0JnEYBZsJuN7lYKLZUm+c4MXT2daJp0iF5+zxJRqPtvW1rzN7Bi8BHIHJo3jmt8DwyStP9Wr6ctoQAR6gEuXP3Sij/LLVFXi89Rch5EqvQOkD mike@europa
  EOH
end

file "/etc/ssh/sshd_config" do
  owner "root"
  group "root"
  mode "600"
  content <<-EOH
Protocol 2
SyslogFacility AUTHPRIV
StrictModes no
PasswordAuthentication yes
ChallengeResponseAuthentication no
GSSAPIAuthentication yes
GSSAPICleanupCredentials yes
UsePAM yes
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
X11Forwarding yes
Subsystem       sftp    /usr/libexec/openssh/sftp-server
  EOH
end

