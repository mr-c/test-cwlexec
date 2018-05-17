#!/bin/bash
user=$1
useradd ${user}
mkhomedir_helper ${user}
find / -group docker -exec chgrp -hf --reference /var/run/docker.sock {} \;
groupmod --non-unique --gid $(stat --format %g /var/run/docker.sock) docker
usermod -a -G docker ${user}
cp -r /home/lsfadmin/cwlexec* /home/${user}
chown ${user} /home/${user} /home/${user}/cwlexec*
chmod +777 /home/${user}
chmod +777 /home/${user}/cwl* -R
source /opt/ibm/lsfsuite/lsf/conf/profile.lsf
source <(head -n265 /start_lsf_ce.sh | tail -n +7)
ROLE=master config_lsfce
ROLE=master start_lsf
lsid
lshosts
su ${user} -c "source /opt/ibm/lsfsuite/lsf/conf/profile.lsf && \
	/cwl/run_test.sh \
	RUNNER=~/cwlexec-0.1/cwlexec \
	--junit-xml=/home/${user}/cwl-workdir/cwlexec.xml" || /bin/true

