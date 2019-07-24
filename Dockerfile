FROM centos

LABEL version="0.1"
LABEL maintainer="dtorrejon"
LABEL email="david.torrejon.vazquez@gmail.com"
LABEL hadoop_version="hadoop-3.2.0."
LABEL java_version="jdk-8u221"

#COPY JAVA & HADOOP bin files
COPY /vol/hadoop/ .
COPY /vol/java8/ .

#INSTALLING PACKAGES
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
                   cean all \

 #HADOOP INSTALLATION 
 && cat hadoop-3.2.0.tar.gz-* > hadoop-3.2.0.tar.gz \
 && tar -zxvf hadoop-3.2.0.tar.gz -C /opt/ \
 && rm hadoop-3.2.0.tar.gz \
 && rm hadoop-3.2.0.tar.gz-* \
 
#CREATING HADOOP USER
 && useradd -ms /bin/bash hadoop \
 && usermod -aG root hadoop \
 && chown -R hadoop:hadoop /opt/hadoop-3.2.0 \
 && mkdir -p /opt/data/datanode \ 
 && mkdir -p /opt/data/namenode \
 && chown -R hadoop:hadoop /opt/data \
 && echo -e "ChangeThePassw0rd\nChangeThePassw0rd\n" | passwd hadoop \

#JAVA INSTALLATION

 && cat jdk-8u221-linux-x64.rpm-* > jdk-8u221-linux-x64.rpm \
 && rpm -ivh jdk-8u221-linux-x64.rpm \
 && rm jdk-8u221-linux-x64.rpm \
 && rm jdk-8u221-linux-x64.rpm-* 


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

#scrip test
COPY /vol/MRTest.sh /home/hadoop/map-reduce-test.sh

# Change to hadoop user
USER hadoop

#SSH configuration
RUN sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N '' \
 && sudo ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N '' \
 && sudo ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N '' \
 && sudo ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N '' \
 && ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N '' \
 && cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/authorized_keys \
 && cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/known_hosts \


#HDFS format
 && /opt/hadoop-3.2.0/bin/hdfs namenode -format 

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

#Enter as HADOOP user
WORKDIR /home/hadoop
ENTRYPOINT ["./entrypoint.sh"]

