FROM continuumio/miniconda3:latest

ENV HADOOP_HOME /opt/hadoop
ENV SPARK_HOME /opt/spark
ENV LIVY_HOME /opt/livy
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HOME /root

# update and install required dependencies
RUN \
  apt-get update && apt-get install -y \
  openssh-server \
  rsync \
  vim \
  sudo \
  zip \
  openjdk-8-jdk --fix-missing -y

# downloading and setting up hadoop and spark
RUN \
  wget http://mirrors.estointernet.in/apache/hadoop/common/hadoop-2.8.4/hadoop-2.8.4.tar.gz && \
  wget http://archive.apache.org/dist/spark/spark-2.4.2/spark-2.4.2-bin-hadoop2.7.tgz && \
  wget http://archive.apache.org/dist/incubator/livy/0.5.0-incubating/livy-0.5.0-incubating-bin.zip && \
  tar xzf hadoop-2.8.4.tar.gz && \
  tar xzf spark-2.4.2-bin-hadoop2.7.tgz && \
  unzip livy-0.5.0-incubating-bin.zip && \
  mv hadoop-2.8.4 $HADOOP_HOME && \
  mv spark-2.4.2-bin-hadoop2.7 $SPARK_HOME && \
  mv livy-0.5.0-incubating-bin $LIVY_HOME && \
  rm -rf hadoop-2.8.4.tar.gz spark-2.4.2-bin-hadoop2.7.tgz livy-0.5.0-incubating-bin.zip && \
  mkdir -p /opt/hadoop/data/hdfs/namenode && \
  mkdir -p /opt/hadoop/data/hdfs/datanode

# generating ssh key and setting up for password less ssh
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

# copy spark and hadoop config files
COPY config/*xml $HADOOP_HOME/etc/hadoop/
COPY config/spark-defaults.conf $SPARK_HOME/conf/
COPY config/ssh_config /root/.ssh/config
COPY config/env.sh /tmp/env.sh
COPY script/start-hadoop.sh .
COPY config/requirements.txt .

# install jupyter and setting up for spark
RUN pip install jupyter
RUN pip install -r requirements.txt
RUN mkdir -p ${HOME}/notebooks

WORKDIR ${HOME}

COPY libs/*.zip .
RUN unzip s3libs.zip && rm -f s3libs.zip

RUN jupyter notebook --generate-config
RUN ipython profile create pyspark
RUN mkdir -p .ipython/kernels/pyspark

COPY config/00-default-setup.py .ipython/profile_pyspark/startup/
COPY config/00-default-setup.py .ipython/profile_default/startup/
COPY config/kernel.json .ipython/kernels/pyspark
COPY config/jupyter_notebook_config.py .jupyter/

RUN /tmp/env.sh && rm -f /tmp/env.sh
RUN chmod +x /start-hadoop.sh

EXPOSE  2222 4040 8020 8030 8031 8032 8033 8042 8088 50070 50075 8888 8998

CMD ["sh", "-c" ,"/start-hadoop.sh"]
