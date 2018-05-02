#!/bin/bash
source /usr/share/lsf/conf/profile.lsf
find / -group docker -exec chgrp -hf --reference /var/run/docker.sock {} \;
groupmod --gid $(stat --format %g /var/run/docker.sock) docker
usermod -a -G docker lsfadmin
sed -i s/coordinator/$(hostname)/g /usr/share/lsf/conf/lsf.cluster.cluster1 \
	/usr/share/lsf/conf/lsf.conf \
	/usr/share/lsf/conf/lsbatch/cluster1/configdir/lsb.hosts \
	/usr/share/lsf/conf/ego/cluster1/kernel/ego.conf
/usr/share/lsf/10.1/install/hostsetup --top=/usr/share/lsf
service ssh start
ssh-keyscan $(hostname) >> ~/.ssh/known_hosts
yes | lsfstartup
lsid
su lsfadmin -c 'source /usr/share/lsf/conf/profile.lsf && lshosts && \
	pushd ~/cwlexec-master/src/test/integration-test && \
	bash ./run.sh || /bin/true && popd && \
	/common-workflow-language-master/run_test.sh \
	RUNNER=/cwlexec-0.1/cwlexec \
	--junit-xml=/home/lsfadmin/cwlexec-0.1.xml' || /bin/true

