This repository documents testing various version and configurations of IBM
Spectrum LSF and their Common Workflow Language executor (CWLEXEC) against the
CWL v1.0 conformance tests.

IBM Spectrum LSF Community Edition 10.1
---------------------------------------
This edition of LSF does not include the LSF Docker for workloads feature, but
cwlexec and bsub users are able to call docker directly (if available)

It is limited to single or dual-socket processor hosts; so a VM (or real machine) with
only one or two CPU sockets is supported.

To run the test:

```
cd lsf-ce-10.1
docker build --tag lsf-ce-10.1-cwlexec .

docker run -v /var/run/docker.sock:/var/run/docker.sock:rw \
	-v /home/${USER}/cwl-workdir:/home/${USER}/cwl-workdir:rw \
	lsf-ce-10.1-cwlexec ${USER}
```

Current results: `105 tests passed, 4 failures, 19 unsupported features`

I don't know of any Docker container executor that correctly lies/presents the
number of processors actually available, so a VM or real machine with no more
than two CPUs is necessary for all Community Edition coordinators ("master")
and workers ("slave") hosts.

More on the differences between the LSF editions:
https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/New%20IBM%20Platform%20LSF%20Wiki/page/LSF%20Community%20Edition%20and%20LSF%20Suites%20compared

IBM Spectrum LSF 10.1.0.4 Nov 20 2017 evaluation version
--------------------------------------------------------

This time limited evaluation version does not contain any restrictions on the
number of processors.

https://www-01.ibm.com/marketing/iwm/iwm/web/preLogin.do?source=swerpsysz-lsf-3

```
cd lsf-eval-10.1.0.4
cp $DOWNLOAD/lsf10.1_lsfinstall_linux_x86_64.tar.Z .
cp $DOWNLOAD/lsf10.1_linux2.6-glibc2.3-x86_64.tar.Z .
docker build --tag lsf-eval-10.1.0.4 .
docker run -v /var/run/docker.sock:/var/run/docker.sock lsf-eval-10.1.0.4
```

Current results: `73 tests passed, 36 failures, 19 unsupported features`

---
Docker notes

Non Community Edition versions of LSF 10.1 starting with Fix Pack 1 and onwards
support the use of Docker Engine (Version 1.12+) for the execution of
workloads (or jobs in CWL parlance).

https://www.ibm.com/support/knowledgecenter/SSWRJV_10.1.0/lsf_docker/lsf_docker_prepare.html

--

Not tested
LSF + Singularity or LSF + shifter for container execution
LSF + Amazon Web Services
LSF + containers + Windows hosts (unknown if a supported configuration)

