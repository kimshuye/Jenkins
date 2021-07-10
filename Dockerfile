FROM jenkins/jenkins:2.263.1

ENV JENKINS_HOME=/var/jenkins_home

USER root

COPY requirements.txt requirements.txt

# Install Docker from official repo
RUN apt-get update -qq && \
    apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common wget && \
    apt-get install -qqy build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget && \
    wget https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz && \
    tar xzf Python-3.9.4.tgz && \
    cd Python-3.9.4 && ./configure --enable-optimizations && make altinstall && cd .. && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update -qq && \
    apt-get install -qqy docker-ce docker-ce-cli python3-pip nano && \
    groupmod --gid 998 docker && \
    usermod -aG docker,sudo jenkins 

RUN apt-get update -qq && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash -  && \
    apt-get install -qqy nodejs && \
    apt-get install -qqy npm && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R jenkins:jenkins $JENKINS_HOME && \
    apt-get install -qqy default-mysql-client && \
    pip3 install -r requirements.txt
    # chown root:docker /var/run/docker.sock 

USER jenkins

WORKDIR $JENKINS_HOME

ENV HOME=/home/jenkins

# ENV GOROOT=/usr/local/go
# ENV GOPATH=$GOROOT
# ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

RUN sudo mkdir -p $HOME && sudo chown -R jenkins:jenkins $HOME

RUN sudo apt-get update -qq && \
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  && \
    sudo chmod +x /usr/local/bin/docker-compose && \
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose



# VOLUME /var/jenkins_home


