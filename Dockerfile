FROM centos:7.6.1810

ADD vol vol

USER root

WORKDIR /

RUN yum install epel-release -y \
 && yum update -y \
 && yum install -y openssh-server \
                   sudo\
                   initscripts \
                   rsync \
                   openssh \
                   openssh-clients \
                   openssl-libs \
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


COPY /vol/xml/core-site.xml /opt/hadoop-3.2.0/etc/hadoop/core-site.xml
COPY /vol/xml/hdfs-site.xml /opt/hadoop-3.2.0/etc/hadoop/hdfs-site.xml
COPY /vol/runscript.sh /home/hadoop/runscript.sh
COPY /vol/bashrc.txt /home/hadoop/.bashrc
COPY /vol/bashrc.txt /root/.bashrc
COPY /vol/sudoers.txt /etc/sudoers
COPY /vol/sshd_config.txt /etc/ssh/sshd_config
COPY /vol/hadoop-env.sh /opt/hadoop-3.2.0/etc/hadoop/hadoop-env.sh

EXPOSE 22
EXPOSE 9000 8088 9870 19888

USER hadoop

WORKDIR /home/hadoop
ENTRYPOINT ["./runscript.sh"]

