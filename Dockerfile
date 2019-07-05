FROM centos:7.6.1810

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

#ADD /vol/keys/sshd/ /etc/ssh/
#ADD /vol/keys/ssh/ /home/hadoop/.ssh/ 
ADD /vol/xml/ /opt/hadoop-3.2.0/etc/hadoop/
ADD /vol/runscript.sh /home/hadoop/runscript.sh
ADD /vol/bashrc.txt /home/hadoop/.bashrc
ADD /vol/bashrc.txt /root/.bashrc
ADD /vol/sudoers.txt /etc/sudoers
ADD /vol/sshd_config.txt /etc/ssh/sshd_config
ADD /vol/hadoop-env.sh /opt/hadoop-3.2.0/etc/hadoop/hadoop-env.sh

VOLUME /tmp/keys/ssh/:/home/
VOLUME /tmp/keys/sshd/:/etc/ssh/

EXPOSE 22 \
       9000 \
       8088 \
       9870 \
       19888


USER hadoop
WORKDIR /home/hadoop
ENTRYPOINT ["./runscript.sh"]

