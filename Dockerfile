FROM centos

COPY /vol/jdk12/ .

#HADOOP & JAVA INSTALLATION
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
 && rm hadoop-3.2.0.tar.gz \
 && useradd -ms /bin/bash hadoop \
 && usermod -aG root hadoop \
 && chown -R hadoop:hadoop /opt/hadoop-3.2.0 \
 && mkdir -p /opt/data/datanode \ 
 && mkdir -p /opt/data/namenode \
 && chown -R hadoop:hadoop /opt/data \

#DEFAULT PASSWORD FOR HADOOP USERNAME
 && echo -e "ChangeThePassw0rd\nChangeThePassw0rd\n" | passwd hadoop \
 && yum clean all

#JAVA jdk_12.0.2 install from local file

RUN cat jdk-12.0.2_linux-x64_bin.rpm-* > jdk-12.0.2_linux-x64_bin.rpm \
&& rpm -ivh jdk-12.0.2_linux-x64_bin.rpm \
&& rm jdk-12.0.2_linux-x64_bin.rpm \
&& rm jdk-12.0.2_linux-x64_bin.rpm-*


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

#Enter as HADOOP user
USER hadoop

#HDFS format
RUN /opt/hadoop-3.2.0/bin/hdfs namenode -format \

#&& sed -i s/localhost/`hostname`/g /opt/hadoop-3.2.0/etc/hadoop/core-site.xml \

#SSH configuration
&& sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N '' \
&& sudo ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N '' \
&& sudo ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N '' \
&& sudo ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N '' \
&& ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N '' \
&& cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/authorized_keys \
&& cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/known_hosts

#SSH
EXPOSE 22 \

#HDFS
#NameNode WEB INTERFACE
       9870 \
       9871 \

#ResourceManager WEB INTERFACE
       8088 \ 

#Data Node. All slave nodes
       9864 \
       9866 \
       9867 \

#Secondary NameNode and any backup NameNodes
       9868 \
       9869 \

#JournalNode
       8485 \
       8480 \
       8481 \

#Aliasmap Server
       50200 \


#MAPREDUCE
#Service

#MapReduce Job History
       10020 \

#MapReduce Job History UI
       19888 \
       19890 \

#YARN
        8032 \
        8030 \
        8088 \
        8090 \
        8031 \
        8033 \
        8040 \
        8048 \
        8042 \
        8044 \
        10200 \
        8188 \
        8190 \
        8047 \
        8788 \
        8046 \
        8045 \
        8049 \
        8089 \
        8091 \

#History server admin
       10033 \

#fs.defaultFS
       9000


WORKDIR /home/hadoop
ENTRYPOINT ["./entrypoint.sh"]

