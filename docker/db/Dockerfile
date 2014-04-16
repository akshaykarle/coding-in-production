FROM centos-chef-solo

ADD berks /berkshelf

RUN mkdir -p /var/log/chef
RUN chef-solo -c /berkshelf/solo.rb -o "role[db]"

EXPOSE 5432

CMD /etc/init.d/postgresql-9.3 start
