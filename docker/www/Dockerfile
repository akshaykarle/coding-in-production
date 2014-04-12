FROM centos-berkshelf

ADD berks /berkshelf

RUN cd berkshelf; berks install --path /berkshelf/cookbooks

RUN mkdir -p /var/log/chef
RUN gem update rake --force
RUN mkdir -p /etc/nginx/conf.d
RUN chef-solo -c berkshelf/solo.rb -o "role[www]"
