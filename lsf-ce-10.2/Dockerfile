FROM ibmcom/lsfce:10.2.0
RUN apt-get update && apt-get install -y \
	openjdk-8-jdk-headless \
	python3-pip
RUN pip3 install cwltest
ADD https://github.com/IBMSpectrumComputing/cwlexec/releases/download/v0.1/cwlexec-0.1.tar.gz /
ADD https://github.com/common-workflow-language/common-workflow-language/archive/master.tar.gz /
RUN tar xzf cwl*tar.gz && tar xzf master*tar.gz
RUN [ "/bin/bash", "-c", "source /opt/ibm/lsfsuite/lsf/conf/profile.lsf && source <(head -n265 /start_lsf_ce.sh | tail -n +7) && ROLE=master config_lsfce && ROLE=master start_lsf && lsid && lshosts && su lsfadmin -c 'source /opt/ibm/lsfsuite/lsf/conf/profile.lsf && /common-workflow-language-master/run_test.sh RUNNER=/cwlexec-0.1/cwlexec --junit-xml=/home/lsfadmin/cwlexec-0.1.xml' || /bin/true" ]
ENTRYPOINT ""
