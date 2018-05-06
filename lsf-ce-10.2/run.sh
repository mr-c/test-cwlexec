#!/bin/bash
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

