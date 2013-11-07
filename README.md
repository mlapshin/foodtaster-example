# Foodtaster Example Project

This repository shows how to use
[Foodtaster](http://github.com/mlapshin/foodtaster) to write specs for
Chef cookbooks.

Layout of this repository resembles layout of any other [Chef
Repo](http://docs.opscode.com/essentials_repository.html), except for
directories not required in this example, like `data_bags`, `environments`
and `roles`. You can create them if you need.

Directory `cookbooks` contains community cookbooks which are installed
using [Berkshelf](http://berkshelf.com), `site-cookbooks` is for
cookbooks you develop. `spec` is a directory where all automated test
scripts (specs) are stored.

## Running specs

Before running specs, you should install
[Vagrant](http://vagrantup.com) with
[vagrant-foodtaster-server](https://github.com/mlapshin/vagrant-foodtaster-server)
plugin. Follow official Vagrant installation instructions, and then
invoke command:

    vagrant plugin install vagrant-foodtaster-server

Clone this repository using git:

    git clone https://github.com/mlapshin/foodtaster-example.git

Next, invoke Bundler to install all required gems:

    cd foodtaster-example
    bundle install

Finally, invoke Berkshelf to install community cookbooks in
`cookbooks` directory:

    berks install --path cookbooks

Now you should be able to run specs with:

    rspec spec

## Examples Description

This repository contains two cookbooks, `nginx_example` and
`nfs_example`. There are specs for both of them located in `spec`
folder.

### nginx_example

This cookbook installs `nginx` package on Ubuntu system without any
configuration.

It's spec file `spec/nginx_cookbook_spec.rb` uses different Foodtaster
matchers to check if nginx server was installed and working properly.
Read comments in spec file for more details.

### nfs_example

More complicated example which installs
[NFS](http://en.wikipedia.org/wiki/Network_File_System) server and
creates NFS mounts on client.

It's spec `spec/nfs_cookbook_spec.rb` shows how to use several VMs to
make cross-machine (integration) tests. In this spec one VM is an NFS
server and second is a client. Spec make some operations in NFS volume
on one VM and check if they are propagated to other. Read comments in
spec file for more details.
