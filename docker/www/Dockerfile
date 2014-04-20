FROM centos-chef-solo

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN yum install -y gcc
RUN yum install openssl openssl-devel -y
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

ADD nginx.conf /etc/nginx/sites-available/default

EXPOSE 80

CMD service nginx start