require 'spec_helper'

describe "example::default" do
  run_chef_on :vm0 do |c|
    c.json = {}
    c.add_recipe 'pg::default'
  end

  def exec_sql(vm, command)
    vm.execute("su postgres -c \"#{command}\"")
  end

  it "install postgres" do
    pg_ls = vm0.execute('pg_lsclusters').stdout
    pg_ls.should include('main')

    p exec_sql(vm0, "psql -d postgres -c '\\l'").stderr
  end
end
