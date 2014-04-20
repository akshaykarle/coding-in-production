FROM centos-chef-solo

ADD chef /chef

RUN mkdir -p /var/log/chef
RUN chef-solo -c /chef/solo.rb -o "role[db]"

ENV PATH /usr/pgsql-9.3/bin:$PATH

EXPOSE 5432

CMD su postgres -c 'postgres -D /var/lib/pgsql/9.3/data/'
