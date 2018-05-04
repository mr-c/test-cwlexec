FROM debian as cwlexec-builder
RUN apt-get update && apt-get install -y --no-install-recommends \
	maven \
        openjdk-8-jdk-headless \
  && rm -rf /var/lib/apt/lists/*
ADD https://github.com/IBMSpectrumComputing/cwlexec/archive/master.tar.gz /root
WORKDIR /root
RUN tar xzf master.tar.gz
WORKDIR /root/cwlexec-master
RUN mvn package -Dmaven.test.skip=true

FROM debian as lsf-main
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
  && curl -fsSL https://download.docker.com/linux/debian/gpg \
  | apt-key add - && \
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
  && apt-get update && apt-get -y install docker-ce \
  && rm -rf /var/lib/apt/lists/*
RUN adduser --disabled-password --gecos '' lsfadmin
COPY ./lsf10.1_lsfinstall_linux_x86_64.tar.Z /root/
COPY ./lsf10.1_linux2.6-glibc2.3-x86_64.tar.Z /root/
RUN tar xzf /root/lsf10.1_lsfinstall_linux_x86_64.tar.Z --directory /root
COPY ./install.config /root/
RUN cd /root/lsf10.1_lsfinstall/ && echo 1 | ./lsfinstall -f /root/install.config
# RUN echo LSB_RESOURCE_ENFORCE=\"cpu memory\" >> /usr/share/lsf/conf/lsf.conf && \
# 	sed -i '/End Resource/i \
#    docker     Boolean ()       ()         (Docker container)' \
# 	/usr/share/lsf/conf/lsf.shared && sed -i 's/mg/mg docker/' \
# 	/usr/share/lsf/conf/lsf.cluster.cluster1
COPY --from=cwlexec-builder --chown=lsfadmin:lsfadmin /root/cwlexec-master /home/lsfadmin/cwlexec-master
RUN ssh-keygen -q -f /root/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub \
	> ~/.ssh/authorized_keys && echo PubkeyAuthentication yes \
	>> /etc/ssh/sshd_config
RUN pip3 install cwltest
COPY startup.sh /
ENTRYPOINT /startup.sh

