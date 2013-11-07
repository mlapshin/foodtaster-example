# Foodtaster Example Project

This repository shows how to use
[Foodtaster](http://github.com/mlapshin/foodtaster) to write specs for
Chef cookbooks.

Layout of this repository resembles layout of any other [Chef
Repo](http://docs.opscode.com/essentials_repository.html), except for
directories not required in this example, like `data_bags`, `environments`
and `roles`.

`cookbooks` directory contains community cookbooks declared in
Berksfile. `site-cookbooks` is a directory for your own cookbooks.

## Running specs

Before running specs, you should install
[Vagrant](http://vagrantup.com) and
[vagrant-foodtaster-server](https://github.com/mlapshin/vagrant-foodtaster-server)
Vagrant plugin.

Clone this repository using git and 

    git clone https://github.com/mlapshin/foodtaster-example.git

Next, invoke Bundler to install all required gems including
Foodtaster:

    cd foodtaster-example
    bundle install

Finally, invoke Berkshelf to install community cookbooks in
`cookbooks` directory:

    berks install --path cookbooks

Now you should be ready to run specs with:

    rspec spec
