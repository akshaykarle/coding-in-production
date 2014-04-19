FROM centos-chef-solo

ADD chef /chef

RUN mkdir -p /var/log/chef
RUN chef-solo -c /chef/solo.rb -o "role[db]"

EXPOSE 5432

CMD su postgres -c '/usr/pgsql-9.3/bin/postgres -D /var/lib/pgsql/9.3/data/'
