#
# Cookbook Name:: example
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

file "/tmp/example_file.txt" do
  content "hello from example cookbook"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

user "example_user" do
  shell "/bin/bash"
end
