FROM ibmcom/lsfce:10.2.0 as cwlexec-builder
RUN apt-get update && apt-get install -y --no-install-recommends \
	maven \
        openjdk-8-jdk-headless \
  && rm -rf /var/lib/apt/lists/*
ADD https://github.com/IBMSpectrumComputing/cwlexec/archive/master.tar.gz /root
WORKDIR /root
RUN tar xzf master.tar.gz
WORKDIR /root/cwlexec-master
RUN mvn package -Dmaven.test.skip=true

FROM ibmcom/lsfce:10.2.0
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        ed \
        gnupg2 \
        openjdk-8-jre-headless \
        openssh-server \
        python-minimal \
        python3-pip \
        python3-setuptools\
        python3-wheel \
        software-properties-common \
        vim-tiny \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | apt-key add - && \
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  && apt-get update && apt-get -y install docker-ce \
  && rm -rf /var/lib/apt/lists/*
RUN pip3 install cwltest
ADD https://github.com/common-workflow-language/common-workflow-language/archive/master.tar.gz /
COPY --from=cwlexec-builder --chown=lsfadmin:lsfadmin /root/cwlexec-master /home/lsfadmin/cwlexec-master
USER lsfadmin
RUN tar xzf /home/lsfadmin/cwlexec-master/target/*.tar.gz --directory /home/lsfadmin
USER root
RUN tar xzf master.tar.gz
ADD run.sh /
ENTRYPOINT /run.sh
