require 'spec_helper'

# This spec is an example of interation spec, i.e. where more that on
# VM is used. In this spec we create simple NFS setup and test it
# using different filesystem operations. We're expecting that changes
# made on one VM will also appear on other.
describe 'nfs_example cookbook' do

  # vm0 is an NFS server, we setup it with "nfs_example::default"
  # recipe.
  run_chef_on :vm0 do |c|
    c.add_recipe "nfs_example::default"
  end

  # vm1 is a client
  run_chef_on :vm1 do |c|
    c.json = { nfs_server_ip: vm0.ip }
    c.add_recipe "nfs_example::client"
  end

  # create aliases for our VMs
  let(:server) { vm0 }
  let(:client) { vm1 }

  # check if NFS server was properly configured
  it "should install nfs server on server" do
    server.should listen_port(32765)
    server.should have_running_process("nfsd")
  end

  # check if NFS mountpoint exists on client
  it "should mount nfs partition on client" do
    client.execute("mount | grep nfs").should be_successful
  end

  it "should have same content of /nfs dir on both server and client machines" do
    token = Time.now.to_s

    # create file on client and check if it will appear on server
    client.execute("echo #{token} > /nfs/test.txt").should be_successful
    server.should have_file("/nfs/test.txt").with_content(token)

    # same, but when we delete a file
    server.execute("rm /nfs/test.txt")
    client.should_not have_file("/nfs/test.txt")

    # and last check is for directory
    server.execute("mkdir /nfs/smth")
    client.should have_directory("/nfs/smth")
  end
end
