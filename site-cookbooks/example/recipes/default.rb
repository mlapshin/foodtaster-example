execute "update apt sources" do
  command 'apt-get update'
end

package 'nginx' do
  action :install
end
