FROM centos:7.6.1810

ADD vol vol

USER root

WORKDIR /

RUN yum install epel-release -y \
 && yum update -y \
 && yum install -y openssh \
                  openssh-server \
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
 && chown -R hadoop:hadoop /opt/data


COPY /vol/xml/core-site.xml /opt/hadoop-3.2.0/etc/hadoop/core-site.xml
COPY /vol/xml/hdfs-site.xml /opt/hadoop-3.2.0/etc/hadoop/hdfs-site.xml
COPY /vol/runscript.sh /home/hadoop/runscript.sh
COPY /vol/bashrc.txt /home/hadoop/.bashrc

USER hadoop
WORKDIR /home/hadoop

#EXPOSE 9000 22 8088 9870 19888

ENTRYPOINT ["./runscript.sh"]

