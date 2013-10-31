#
# Cookbook Name:: packages
# Recipe:: default
#
# Copyright 2013, Mike Adamson
#
# All rights reserved - Do Not Redistribute
#
node["packages"]["apps"].each do |app|
	package app
end

