require 'spec_helper'

# This simple spec install nginx on vm0 and demonstrates usage of
# different Foodtaster matchers.
describe "nginx_example::default" do
  run_chef_on :vm0 do |c|
    c.json = {}
    c.add_recipe 'nginx_example::default'
  end

  it "should install nginx as a daemon" do
    # check if system package was installed
    vm0.should have_package 'nginx'

    # check if user www-data exist
    vm0.should have_user('www-data').in_group('www-data')

    # check if nginx process is running
    vm0.should have_running_process("nginx")

    # check if port is open
    vm0.should listen_port(80)

    # check if init.d service exist
    vm0.should have_file("/etc/init.d/nginx")

    # check for default config file
    vm0.should have_file("/etc/nginx/nginx.conf").with_content(/gzip on/)
  end

  it "should be able to restart nginx" do
    # restart server using custom shell command and check it's exit code
    vm0.execute("service nginx restart").should be_successful
  end

  it "should have valid nginx config" do
    # Ask nginx to check it's config file syntax
    result = vm0.execute("nginx -t")

    # result now contains STDOUT, STDERR and exit status of command.
    result.should be_successful
    result.stderr.should include("/etc/nginx/nginx.conf syntax is ok")
  end

  it "should respond on http with welcome page" do
    # Check if nginx responds to GET queries with wget utility
    result = vm0.execute("wget http://localhost -O /tmp/index.html && cat /tmp/index.html")
    result.stdout.should include("Welcome to nginx")
  end

  it "should successful run recipe second time" do
    # Run Chef second time to check if it will converge already
    # converged node without errors
    repeat_chef_run :vm0
  end
end
