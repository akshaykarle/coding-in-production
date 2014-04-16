FROM centos-chef-solo

ADD berks /berkshelf

RUN mkdir -p /var/log/chef
RUN chef-solo -c /berkshelf/solo.rb -o "role[db]"

EXPOSE 5432

CMD su postgres -c '/usr/pgsql-9.3/bin/pg_ctl start -D /var/lib/pgsql/9.3/data/'
