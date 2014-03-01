FROM ubuntu
MAINTAINER Henrik Mühe
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q -y update
RUN apt-get -q -y install curl

RUN curl -L https://get.rvm.io | bash -s stable --ruby

RUN mkdir /var/run/sshd
RUN echo 'root:password' > /root/passwdfile
RUN cat /root/passwdfile | chpasswd

RUN apt-get -q -y install build-essential
RUN apt-get -q -y install git-core

# Install node
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install software-properties-common python-software-properties python g++ make vim
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y install nodejs
RUN npm install -g bower
RUN apt-get -y install sudo openssh-server
RUN apt-get -q -y install sysklogd tmux

# Install user
RUN useradd -m user

# Install source
ADD . /src

EXPOSE 22 8080
ENTRYPOINT ["/src/startup.sh"]
