require 'spec_helper'

describe "example cookbook" do
  run_chef_on :vm0 do |chef|
    chef.json = {}
    chef.add_recipe "example::default"
  end

  it "should create some file" do
    vm0.should_not be_nil
    vm0.execute("cat /tmp/example_file.txt").stdout.should == 'hello from example cookbook'
  end

  it "should create example user" do
    vm0.should have_user("example_user").in_group("example_user")
  end
end
