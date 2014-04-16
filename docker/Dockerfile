FROM centos

RUN yum install -y git-core

RUN curl https://opscode.com/chef/install.sh | bash

RUN echo "NETWORKING=yes" > /etc/sysconfig/network
