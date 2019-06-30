FROM centos:7.6.1810

ADD vol vol

USER root

WORKDIR /

RUN yum install epel-release -y \
 && yum update -y \
 && yum install -y openssh-server openssl sudo\
                  initscripts \
                  rsync \
                  openssh \
                  openssh-clients openssl-libs \
                  pdsh \
                  wget \
 && wget http://us.mirrors.quenda.co/apache/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz \
 && tar -zxvf hadoop-3.2.0.tar.gz -C /opt/ \
 && curl -LO -H "Cookie: oraclelicense=accept-securebackup-cookie" \
"https://download.oracle.com/otn-pub/java/jdk/12.0.1+12/69cfe15208a647278a19ef0990eea691/jdk-12.0.1_linux-x64_bin.rpm" \
 && rpm -ivh jdk-12.0.1_linux-x64_bin.rpm \
 && rm jdk-12.0.1_linux-x64_bin.rpm \
 && useradd -ms /bin/bash hadoop \
 && usermod -aG root hadoop \
 && chown -R hadoop:hadoop /opt/hadoop-3.2.0 \
 && mkdir -p /opt/data/datanode \ 
 && mkdir -p /opt/data/namenode \
 && chown -R hadoop:hadoop /opt/data \
 && echo -e "ChangeThePassw0rd\nChangeThePassw0rd\n" | passwd hadoop

#RUN mkdir /var/run/sshd
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN chmod 700 /vol/xml/core-site.xml \
 && chmod 700 /vol/xml/hdfs-site.xml \
 && chmod 700 /vol/runscript.sh  \
 && chmod 700 /vol/sudoers.txt \
 && chmod 700 /vol/sshd_config.txt \
 && chmod 700 /vol/hadoop-env.sh
COPY /vol/xml/core-site.xml /opt/hadoop-3.2.0/etc/hadoop/core-site.xml
COPY /vol/xml/hdfs-site.xml /opt/hadoop-3.2.0/etc/hadoop/hdfs-site.xml
COPY /vol/runscript.sh /home/hadoop/runscript.sh
COPY /vol/bashrc.txt /home/hadoop/.bashrc
COPY /vol/sudoers.txt /etc/sudoers
COPY /vol/sshd_config.txt /etc/ssh/sshd_config
COPY /vol/hadoop-env.sh /opt/hadoop-3.2.0/etc/hadoop/hadoop-env.sh

#RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''
#RUN ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N ''
#RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N ''
#RUN ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ''
#RUN chmod 700 /etc/ssh/ssh_host_rsa_key \
#&& chmod 700 /etc/ssh/ssh_host_dsa_key \
#&& chmod 700 /etc/ssh/ssh_host_ecdsa_key \
#&& chmod 700 /etc/ssh/ssh_host_ed25519_key

EXPOSE 22
EXPOSE 9000 8088 9870 19888

USER hadoop

#RUN ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
#RUN cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/authorized_keys

WORKDIR /home/hadoop
ENTRYPOINT ["./runscript.sh"]

