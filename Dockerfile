FROM ubuntu:trusty-20181115 as base

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        vim.tiny wget sudo net-tools lsof bash-completion ca-certificates \
        unzip ssh software-properties-common openssh-server \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-add-repository ppa:ansible/ansible \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y python3 \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ansible \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /etc/ansible/keys
RUN mkdir /root/.ssh
RUN mkdir /var/run/sshd

# RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# RUN ssh-keygen -t rsa -b 4096 -f /etc/ansible/keys/key -q -N ""

WORKDIR /etc/ansible
EXPOSE 22