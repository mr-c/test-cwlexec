#!/bin/bash
user=$1
useradd ${user}
mkhomedir_helper ${user}
find / -group docker -exec chgrp -hf --reference /var/run/docker.sock {} \;
groupmod --gid $(stat --format %g /var/run/docker.sock) docker
usermod -a -G docker ${user}
cp -r /home/lsfadmin/cwlexec-master /home/${user}
chmod +777 /home/${user}/cwlexec-master -r
source /opt/ibm/lsfsuite/lsf/conf/profile.lsf
source <(head -n265 /start_lsf_ce.sh | tail -n +7)
ROLE=master config_lsfce
ROLE=master start_lsf
lsid
lshosts
su lsfadmin -c 'source /opt/ibm/lsfsuite/lsf/conf/profile.lsf && \
	/common-workflow-language-master/run_test.sh \
	RUNNER=/home/lsfadmin/cwlexec-0.1/cwlexec \
	--junit-xml=/home/lsfadmin/cwlexec-0.1.xml' || /bin/true

