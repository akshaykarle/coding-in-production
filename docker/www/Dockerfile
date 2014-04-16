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
RUN rbenv rehash

ADD berks /berkshelf

RUN mkdir -p /var/log/chef
RUN gem update rake --force
RUN mkdir -p /etc/nginx/conf.d
RUN chef-solo -c berkshelf/solo.rb -o "role[www]"
