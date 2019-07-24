# HADOOP SINGLE NODE



## INTRO

Hadoop pseudo distributed node container, with yarn-mapreduce configured.

This container runs a Hadoop pseudo distributed node with yarn-mapreduce configured.

```bash
$ docker run -ti -m 2G -p 2222:22 -p 9870:9870 -p 9864:9864 -p 9868:9868 -p 8480:8480 -p 19888:19888 -p 8088:8088 -p 8042:8042 dtorrejon/hadoopsn

Running sshd service...
Configuring SSH Keys...
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/hadoop/.ssh/id_rsa.pub"

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh -o 'StrictHostKeyChecking=no' 'ef802462346a'"
and check to make sure that only the key(s) you wanted were added.

/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/hadoop/.ssh/id_rsa.pub"

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh -o 'StrictHostKeyChecking=no' 'localhost'"
and check to make sure that only the key(s) you wanted were added.

starting hadoop...
Starting namenodes on [ef802462346a]
Starting datanodes
Starting secondary namenodes [ef802462346a]
Starting resourcemanager
Starting nodemanagers
starting service for saving history jobs...
[hadoop@ef802462346a ~]$ 
```





## INSTALLED  SOFTWARE & OS VERSIONS

- CENTOS 7
- HADOOP version: 3.2.0
- JAVA version: jdk-8u221



## PRE-REQUISITES

**This container needs at least 2 GB RAM**

You can modify the parameters in yarn-site.xml & mapred-site.xml files:

```xml
<property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>1536</value>
</property>

<property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>1536</value>
</property>

<property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>128</value>
</property>

<property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
</property>
```



## RUNNIG THE CONTAINER

Mount a named volume in order to persist data

```bash
$ docker volume create hadoopdata

$ docker run -ti -m 2G -p 2222:22 -p 9870:9870 -p 9864:9864 -p 9868:9868 -p 8480:8480 -p 19888:19888 -p 8088:8088 -p 8042:8042 -v hadoopdata:/opt/data dtorrejon/hadoopsn
```

Without named volume

```bash
$ docker run -ti -m 2G -p 2222:22 -p 9870:9870 -p 9864:9864 -p 9868:9868 -p 8480:8480 -p 19888:19888 -p 8088:8088 -p 8042:8042 dtorrejon/hadoopsn
```



### WEB UIs

**SSH** mapped port  2222

**HDFS**

- WebUI for NameNode 9870
- Data Node 9864
- Secondary NameNode 9868
- JournalNode 8480

**Map Reduce**

- MapReduce Job History UI 19888

**YARN**

- http/https address of the RM web application 8088
- http/https address of the NM web application 8042



### SSH ACCESS

**username**: hadoop

**password**: ChangeThePassw0rd

Once you have the container runnig and the ssh port (22) mapped in ypur machine, type:

```bash
$ ssh localhost -l hadoop -p [mapped port]
```

For exampe, if you have the port 2222 mapped:

```bash
$ ssh localhost -l hadoop -p 2222
```

**Please, for your security, change the password**

```bash
$ passwd

Changing password for user hadoop.
Changing password for hadoop.
(current) UNIX password: 
```

### MAP REDUCE TEST

Type this command and test map-reduce

```bash
$ sh /home/hadoop/map-reduce-test.sh
```

map-reduce-test.sh

```bash
#!/bin/bash

hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/hadoop
hdfs dfs -mkdir input
hdfs dfs -put /opt/hadoop-3.2.0/etc/hadoop/*.xml input
hadoop jar /opt/hadoop-3.2.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.0.jar grep input output 'dfs[a-z.]+'
hdfs dfs -get output output
cat output/*
```

Console output result:

```bash
1       dfsadmin
1       dfs.replication
1       dfs.namenode.name.dir
1       dfs.datanode.data.dir
```

