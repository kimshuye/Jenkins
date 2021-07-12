FROM jenkins/jenkins:2.263.1

ENV JENKINS_HOME=/var/jenkins_home
ENV DOCKER_GID=998

ENV HOME=/home/jenkins

WORKDIR $HOME

USER root
RUN mkdir -p $HOME/.local/bin

# Install Docker from official repo
RUN apt-get update -qq && apt-get upgrade -qq && \
    apt-get remove -qqy python3.5 && \
    apt-get install -qqy build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev python3-pip wget && \
    wget https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz && \
    tar xzf Python-3.9.4.tgz && \
    cd Python-3.9.4 && ./configure --enable-optimizations && make altinstall && cd .. && \
    apt-get install -qqy apt-transport-https ca-certificates gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update -qq && \
    apt-get install -qqy docker-ce docker-ce-cli nano && \
    groupmod --gid $DOCKER_GID docker && python3 -V && \
    usermod -aG docker,sudo jenkins && python3 -V && \
    whereis python3

# Install deps + add Chrome Stable + purge all the things
RUN apt-get update && apt-get install -y \
	gnupg \
	--no-install-recommends \
	&& curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update && apt-get install -y \
	google-chrome-stable \
	fontconfig \
	fonts-ipafont-gothic \
	fonts-wqy-zenhei \
	fonts-thai-tlwg \
	fonts-kacst \
	fonts-symbola \
	fonts-noto \
	fonts-freefont-ttf \
	--no-install-recommends \
	&& apt-get purge --auto-remove -y gnupg \
	&& rm -rf /var/lib/apt/lists/*

# Add Chrome as a user
RUN usermod -aG audio,video jenkins

COPY chromedriver /usr/local/bin/chromedriver
RUN chown root:root /usr/local/bin/chromedriver

RUN apt-get update -qq && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash -  && \
    apt-get install -qqy nodejs && \
    apt-get install -qqy npm && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R jenkins:jenkins $JENKINS_HOME && \
    apt-get install -qqy default-mysql-client 
    # chown root:docker /var/run/docker.sock 

USER jenkins

# ENV GOROOT=/usr/local/go
# ENV GOPATH=$GOROOT
# ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

RUN sudo chown -R jenkins:jenkins $HOME
COPY requirements.txt $HOME/requirements.txt
COPY chromedriver $HOME/chromedriver
RUN sudo apt-get update -qq && sudo apt-get upgrade -qq && \
    python3.9 -V && pip3.9 -V && pip3.9 install --upgrade pip && \
    pip3.9 install -r $HOME/requirements.txt && \
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  && \
    sudo chmod +x /usr/local/bin/docker-compose && \
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose 

WORKDIR $JENKINS_HOME

# VOLUME /var/jenkins_home


