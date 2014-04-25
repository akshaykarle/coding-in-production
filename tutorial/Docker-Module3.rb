# Docker
docker

# Look up images
docker images

# Search for images
docker search centos

# Pull an image
docker pull centos

# Run a container
docker run centos bash

# What happened to the container?
# Does it even work?
docker ps -a

# We need to keep the stdin open
# We need a terminal
docker run -i -t centos bash

# Okay it works!
# Lets build a new image with chef

# Introduction to Dockerfile
# on the host machine
mkdir -p docker/base

touch Dockerfile

# Install chef-solo using the omnibus installer
FROM centos

RUN yum install -y git-core

RUN curl https://opscode.com/chef/install.sh | bash


# Now lets build a new image
cd /vagrant/docker/base
docker build -t centos-chef-solo .

docker images
# We have chef-solo now. Lets check that it works.
docker run -i -t centos-chef-solo bash
chef-solo # fails because of missing config files.

# Exit the container.
# Now lets create a database server
# On the host.
mkdir -p docker/db

# Lets download the cookbooks for postgresql-server
cd docker/db
touch Cheffile

# Put in this content:
#!/usr/bin/env ruby

site 'http://community.opscode.com/api/v1'

cookbook 'postgresql'


# Install the cookbooks
mkdir chef
~/coding-in-production/bin/librarian-chef install --path chef/cookbooks

# Now we need a config file to run chef
touch chef/solo.rb

# Paste this content

cookbook_path "/chef/cookbooks"
roles_path    "/chef/roles"
log_location  "/var/log/chef/solo.log"

# Create a role for the database
touch chef/db.json

# Paste the attributes and run_list
{
  "name": "database",
  "chef_type": "role",
  "json_class": "Chef::Role",
  "description": "The base role for the postgresql server",

  "run_list": [
    "recipe[postgresql::yum_pgdg_postgresql]",
    "recipe[postgresql::server]"
  ],

  "override_attributes": {
    "postgresql": {
      "version": "9.3",
      "enable_pgdg_yum": true,
      "password": "postgres",
      "config": {
        "listen_addresses": "*"
      },
      "pg_hba": [
        {
          "type": "local",
          "db": "all",
          "user": "all",
          "addr": "",
          "method": "ident"
        },
        {
          "type": "host",
          "db": "all",
          "user": "all",
          "addr": "0.0.0.0/0",
          "method": "password"
        }
      ]
    }
  }
}


# Now lets create the Dockerfile
touch docker/db/Dockerfile

# Put this in the Dockerfile
FROM centos-chef-solo

ADD chef /chef

RUN mkdir -p /var/log/chef
RUN chef-solo -c /chef/solo.rb -o "role[db]"

ENV PATH /usr/pgsql-9.3/bin:$PATH

EXPOSE 5432

CMD su postgres -c 'postgres -D /var/lib/pgsql/9.3/data/'


# Create the image in vagrant
cd /vagrant/docker/db
docker build -t db .

docker images

# Test it?
docker run -p 5432:5432 -t -i db bash
service postgresql-9.3 start
su - postgres
psql

# Exit the container.
# Next part is to build the web server
# Lets repeat what we did for the database image
mkdir -p docker/www

# Lets download the cookbooks required for the webserver
cd docker/www
touch Cheffile

# Put in this content:
#!/usr/bin/env ruby

site 'http://community.opscode.com/api/v1'

cookbook 'postgresql'
cookbook 'nodejs'


# Install the cookbooks
mkdir chef
~/coding-in-production/bin/librarian-chef install --path chef/cookbooks

# Now we need a config file to run chef
touch chef/solo.rb

# Paste this content

cookbook_path "/chef/cookbooks"
roles_path    "/chef/roles"
log_location  "/var/log/chef/solo.log"

# Create a role for the database
touch chef/www.json

# Paste the attributes and run_list
{
  "name": "webserver",
  "chef_type": "role",
  "json_class": "Chef::Role",
  "description": "The base role for rails web server",

  "run_list": [
    "recipe[postgresql::yum_pgdg_postgresql]",
    "recipe[postgresql]",
    "recipe[nodejs]"
  ],

  "override_attributes": {
    "postgresql": {
      "version": "9.3",
      "enable_pgdg_yum": true,
      "password": "postgres"
    }
  }
}


# Now lets create the Dockerfile
touch docker/www/Dockerfile

# Put this in the Dockerfile
FROM centos-chef-solo

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN yum install -y gcc
RUN yum install openssl openssl-devel -y
RUN yum install tar -y
ENV PATH /.rbenv/bin:/.rbenv/shims:$PATH
RUN rbenv install 2.1.1

RUN rbenv global 2.1.1
RUN gem install rake --force --no-ri --no-rdoc
RUN gem install bundler --no-ri --no-rdoc
RUN rbenv rehash

ADD chef /chef

RUN mkdir -p /var/log/chef
RUN mkdir -p /etc/nginx/conf.d
RUN chef-solo -c chef/solo.rb -o "role[www]"

ENV PATH /.rbenv/bin:/.rbenv/shims:/usr/pgsql-9.3/bin:$PATH


# Create the image in vagrant
cd /vagrant/docker/www
docker build -t www .

docker images

# Before testing your www server
# Lets create a rails app.
# On the host machine
mkdir app
rails new coding-in-production --skip-bundle --database=postgresql

# Now lets run the db server
docker run -p 5432:5432 db

# Now lets see the info of this container
docker inspect <DB CONTAINER ID>

# Look up the IPAddress
docker inspect <DB CONTAINER ID> | grep IPAddress

# Edit your app/YOUR_APP_NAME/config/database.yml of your rails app
  username: postgres
  password: postgres
  host: 172.17.0.2
  port: 5432

# Now lets run the www server
docker run -v /vagrant/app:/var/www:rw -t -i db bash
cd /var/www/
bundle install --path vendor/bundle
bundle exec rake db:create db:migrate
bundle exec rails s

# Now open your browser on the host and goto
192.168.10.10:3000
