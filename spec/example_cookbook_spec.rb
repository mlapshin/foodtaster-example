require 'spec_helper'

describe "example::default" do
  run_chef_on :vm0 do |c|
    c.json = {}
    c.add_recipe 'example::default'
  end

  it "should install nginx as a daemon" do
    vm0.should have_package 'nginx'
    vm0.should have_user('www-data').in_group('www-data')

    vm0.execute("sudo service nginx restart").should be_successful

    vm0.should listen_port(80)
    vm0.should open_page("http://localhost/")

    vm0.should have_file("/etc/init.d/nginx")
    vm0.should have_file("/etc/nginx/nginx.conf").with_content(/gzip on/)
  end

  it "should have valid nginx config" do
    result = vm0.execute("nginx -t")

    result.should be_successful
    result.stderr.should include("/etc/nginx/nginx.conf syntax is ok")
  end

  it "should successful run recipe second time" do
    rerun_chef_on :vm0
  end
end
