FROM centos

RUN yum install -y git-core

RUN curl https://opscode.com/chef/install.sh | bash

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN yum install -y gcc
RUN yum upgrade -y
RUN yum install openssl openssl-devel -y
RUN ~/.rbenv/bin/rbenv install 2.1.1

RUN ~/.rbenv/bin/rbenv global 2.1.1
RUN ~/.rbenv/bin/rbenv rehash
RUN ~/.rbenv/shims/gem install berkshelf
