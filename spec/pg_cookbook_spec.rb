require 'spec_helper'

describe "pg::default" do
  run_chef_on :vm0 do |c|
    c.json = {}
    c.add_recipe 'pg::master'
  end

  run_chef_on :vm1 do |c|
    c.json = {
      pg: {
        master_ip: "192.168.54.100"
      }
    }
    c.add_recipe 'pg::standby'
  end

  let(:master)    { vm0 }
  let(:master_ip) { "192.168.54.100" }
  let(:standby)   { vm1 }

  def exec_sql(vm, command)
    vm.execute("su postgres -c \"#{command}\"")
  end

  it "should setup master cluster" do
    pg_ls = master.execute('pg_lsclusters').stdout
    pg_ls.should include('main')
    pg_ls.should include('5433')
    pg_ls.should include('online')

    p exec_sql(master, "psql -d postgres -c '\\l'")
  end

  it "should create at least one wal log" do
    master.execute("ls /var/lib/postgresql/9.1/main-wals")
  end

  it "should be able to get base backup from standby" do
    standby.execute("su postgres -c 'mkdir -p /tmp/base_backup'")
    result = standby.execute("su postgres -c 'pg_basebackup -h #{master_ip} -p 5433 -D /tmp/base_backup'")
  end

end
