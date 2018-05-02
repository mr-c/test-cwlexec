FROM debian
COPY ./lsf10.1_lsfinstall_linux_x86_64.tar.Z /root/
COPY ./lsf10.1_linux2.6-glibc2.3-x86_64.tar.Z /root/
ADD https://github.com/IBMSpectrumComputing/cwlexec/releases/download/v0.1/cwlexec-0.1.tar.gz /root/
RUN tar xzf /root/lsf10.1_lsfinstall_linux_x86_64.tar.Z --directory /root
# OS support: kernel 2.6/3.0, glibc 2.3 or later
# For kernels above 3.10, lsf10.1_lnx310-lib217-x86_64.tar.Z may be required?

# probably kernel 4.x as well (4.4 for sure) with the other install file
# https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/New%20IBM%20Platform%20LSF%20Wiki/page/LSF%20system%20requirements

# Note only LSF Suite for HPC supports "computational workflows", where the CWL
# editor is likely to appear later
RUN apt-get update && apt-get install -y \
	ed \
        openjdk-8-jdk-headless \
        openssh-server \
	python3-pip \
	vim-tiny \
  && rm -rf /var/lib/apt/lists/*
RUN pip3 install cwltest
RUN adduser --disabled-password --gecos '' lsfadmin
RUN ssh-keygen -f /root/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys && \
	echo PubkeyAuthentication yes >> /etc/ssh/sshd_config
COPY ./install.config /root/
RUN cd /root/lsf10.1_lsfinstall/ && echo 1 | ./lsfinstall -f /root/install.config
ADD https://github.com/common-workflow-language/common-workflow-language/archive/master.tar.gz /root
RUN tar xzf /root/cwl*tar.gz && tar xzf /root/master*tar.gz
RUN ["/bin/sh", "-c", ". /usr/share/lsf/conf/profile.lsf && sed -i s/coordinator/$(hostname)/g /usr/share/lsf/conf/lsf.cluster.cluster1 /usr/share/lsf/conf/lsf.conf /usr/share/lsf/conf/lsbatch/cluster1/configdir/lsb.hosts /usr/share/lsf/conf/ego/cluster1/kernel/ego.conf && /usr/share/lsf/10.1/install/hostsetup --top=/usr/share/lsf && service ssh start && ssh-keyscan $(hostname) >> ~/.ssh/known_hosts && yes | lsfstartup && lsid && su lsfadmin -c 'source /usr/share/lsf/conf/profile.lsf && lshosts && /common-workflow-language-master/run_test.sh RUNNER=/cwlexec-0.1/cwlexec --junit-xml /home/lsfadmin/cwlexec-0.1.xml' || /bin/true"]
