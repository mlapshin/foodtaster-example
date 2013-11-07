package 'nfs-common'

directory "/nfs" do
  action :create
end

mount "/nfs" do
  device "#{node[:nfs_server_ip]}:/nfs"
  fstype "nfs"
  options "rw"
end
