FROM centos

#HADOOP & JAVA INSTALLATION
RUN yum install epel-release -y \
 && yum update -y \
 && yum install -y openssh-server \
                   sudo\
                   initscripts \
                   cronie\
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
#DEFAULT PASSWORD FOR HADOOP USERNAME
 && echo -e "ChangeThePassw0rd\nChangeThePassw0rd\n" | passwd hadoop \
 && yum clean all

#HADOOP config files
COPY /vol/xml/ /opt/hadoop-3.2.0/etc/hadoop/

#Startup script
COPY /vol/entrypoint.sh /home/hadoop/entrypoint.sh

#Files who conatin the enviromet variables config
COPY /vol/bashrc.txt /home/hadoop/.bashrc
COPY /vol/bashrc.txt /root/.bashrc
COPY /vol/hadoop-env.sh /opt/hadoop-3.2.0/etc/hadoop/hadoop-env.sh

#SUDOERS file
COPY /vol/sudoers.txt /etc/sudoers

#SSHD config file
COPY /vol/sshd_config.txt /etc/ssh/sshd_config

#scrip used in order to format & start the pseudo-distributed node
COPY /vol/hadoop-start.sh /home/hadoop/hadoop-start.sh

#SSH port
EXPOSE 22 \

#HDFS PORTS
       9870 \
       50070 \
       50470 \
       8020 \
       9000 \
       50075 \
       50475 \
       50010 \
       50020 \
       50090 \

#MAPREDUCE PORTS
       50090 \  
       8021 \
       50060 \
       51111	



USER hadoop
WORKDIR /home/hadoop
ENTRYPOINT ["./entrypoint.sh"]

