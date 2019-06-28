FROM centos

ADD vol vol

WORKDIR /vol/java

RUN yum install epel-release -y \
&& yum update -y \
&& yum install -y openssh openssh-server openssh-clients openssl-libs \
&& yum install -y pdsh \
&& yum install -y wget \
&& wget http://us.mirrors.quenda.co/apache/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz \
&& tar -zxvf hadoop-3.2.0.tar.gz -C /opt/ \
&& rm hadoop-3.2.0.tar.gz \
&& cat jdk-12.0.1_linux-x64_bin.rpm-* >> jdk-12.0.1_linux-x64_bin.rpm \
&& rpm -ivh jdk-12.0.1_linux-x64_bin.rpm \
&& rm /vol/java/jdk-12.0.1_linux-x64_bin.rpm

COPY /vol/xml/core-site.xml /opt/hadoop-3.2.0/etc/hadoop/core-site.xml
COPY /vol/xml/hdfs-site.xml /opt/hadoop-3.2.0/etc/hadoop/hdfs-site.xml
COPY /vol/runscript.sh /root/runscript.sh
COPY /vol/bashrc.txt /root/.bashrc

WORKDIR /root

ENTRYPOINT ["./runscript.sh"]

