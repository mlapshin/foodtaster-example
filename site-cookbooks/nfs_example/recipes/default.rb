include_recipe 'nfs::server'

directory '/nfs' do
  action :create
end

nfs_export "/nfs" do
  network   '*'
  writeable true
  sync      true
  options   ['no_root_squash']
end
