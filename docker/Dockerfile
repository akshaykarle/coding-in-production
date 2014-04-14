FROM centos

RUN yum install -y git-core

RUN curl https://opscode.com/chef/install.sh | bash

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN yum install -y gcc
RUN yum install openssl openssl-devel -y
ENV PATH /.rbenv/bin:/.rbenv/shims:$PATH
RUN rbenv install 2.1.1

RUN rbenv global 2.1.1

RUN gem install berkshelf -v 2.0.14

RUN rbenv rehash

RUN echo "NETWORKING=yes" > /etc/sysconfig/network
