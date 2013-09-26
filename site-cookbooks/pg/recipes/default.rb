#
# Cookbook Name:: pg
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

[
  'postgresql',
  'postgresql-client'
].each do |pkg|
  package pkg do
    action :install
  end
end

config = {
  data_directory: '/var/lib/postgresql/9.1/main',
  hba_file: '/etc/postgresql/9.1/main/pg_hba.conf',
  ident_file: '/etc/postgresql/9.1/main/pg_ident.conf',
  external_pid_file: '/var/run/postgresql/9.1-main.pid',
  port: 5434,
  max_connections: 100,
  unix_socket_directory: '/var/run/postgresql',
  ssl: 'true',
  shared_buffers: '24MB',
  log_line_prefix: '%t ',
  datestyle: 'iso, mdy',
  lc_messages: 'en_US.utf8',
  lc_monetary: 'en_US.utf8',
  lc_numeric: 'en_US.utf8',
  lc_time: 'en_US.utf8',
  default_text_search_config: 'pg_catalog.english'
}

wal_dir = '/var/lib/postgresql/9.1/main-wals'

master_cfg = {
  wal_level: 'hot_standby',
  max_wal_senders: '5',
  wal_keep_segments: '32',
  archive_mode: 'on',
  archive_command: "cp %p #{wal_dir}/%f"
}

pg_conf = config
.merge(master_cfg)
.map do |k,v|
  "#{k} = '#{v}'"
end.join("\n")


directory wal_dir do
  owner 'postgres'
  group 'postgres'
  mode 00644
  action :create
end

file "/etc/postgresql/9.1/main/postgresql.conf" do
  content pg_conf
  owner 'postgres'
  group 'postgres'
  mode "0755"
  action :create
  notifies :restart, "service[postgresql]", :immediately
end

service "postgresql" do
  action :nothing
end
