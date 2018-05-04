FROM ibmcom/lsfce:10.2.0
RUN apt-get update && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        ed \
        gnupg2 \
        openjdk-8-jdk-headless \
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
ADD https://github.com/IBMSpectrumComputing/cwlexec/releases/download/v0.1/cwlexec-0.1.tar.gz /
ADD https://github.com/common-workflow-language/common-workflow-language/archive/master.tar.gz /
RUN tar xzf cwl*tar.gz && tar xzf master*tar.gz
ENTRYPOINT ""
