# Cookbook Name:: pg
# Recipe:: standby

make_conf = ->(h) {
  h.map do |k,v|
    "#{k} = '#{v}'"
  end.join("\n")
}

['postgresql', 'postgresql-client'].each do |pkg|
  package pkg do
    action :install
  end
end

config = {
  data_directory: '/var/lib/postgresql/9.1/main',
  hba_file: '/etc/postgresql/9.1/main/pg_hba.conf',
  ident_file: '/etc/postgresql/9.1/main/pg_ident.conf',
  external_pid_file: '/var/run/postgresql/9.1-main.pid',
  port: 5433,
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

standby_cfg = config.merge({
  hot_standby: "on"
})

directory wal_dir do
  owner 'postgres'
  group 'postgres'
  mode 00644
  action :create
end

file "/etc/postgresql/9.1/main/postgresql.conf" do
  content make_conf.call(standby_cfg)
  owner 'postgres'
  group 'postgres'
  mode "0755"
  action :create
  notifies :restart, "service[postgresql]", :immediately
end

service "postgresql" do
  action :nothing
end

recovery_conf = {
  standby_mode: 'on',
  primary_conninfo: "host=#{node["pg"]["master_ip"]} port=5433 user=postgres",
}

execute "fetch base backup" do
end

file "/etc/postgresql/9.1/main/recovery.conf" do
  content make_conf.call(recovery_conf)
  owner 'postgres'
  group 'postgres'
  mode "0755"
  action :create
  notifies :restart, "service[postgresql]", :immediately
end
