# docker-hadoop-spark-jupyter
Dockerized hadoop environment with spark, jupyter, livy(REST apis for spark)

### Features!
    
    - Apache Hadoop 2.8.4
    - Apache Spark 2.4.0
    - Jupyter Notebook
    - Conda Environment
    - Apache Livy (REST apis for spark)

### Installation

Pull docker image from docker hub repository
```sh
$ docker pull bhavik9243/hadoop-spark-jupyter:latest
```

### Run/Start/Stop Container

```sh
$ docker run -itd --name hadoop_cluster --hostname localhost -v /Users/bhavik/work/notebooks:/root/notebooks -p 8888:8888 -p 8998:8998 -p 4040:4040 -p 50070:50070 -p 50075:50075 -p 8088:8088 -p 8042:8042 bhavik9243/hadoop-spark-jupyter:latest
$ docker start hadoop_cluster
$ docker stop hadoop_cluster
```

### Namenode UI

> **HDFS** : [http://127.0.0.1:50070](http://127.0.0.1:50070)

### Resource Manager (YARN)

> **YARN** : [http://127.0.0.1:8088](http://127.0.0.1:8088)

### Jupyter Access (with PySpark kernel)

> **Jupyter Notebook** : [http://127.0.0.1:8888](http://127.0.0.1:8888)
>
> **Password** : `letmein`

### LIVY

> **LIVY UI** : [http://127.0.0.1:8998](http://127.0.0.1:8998)
> **Explore more about LIVY** : [https://livy.apache.org/docs/latest/rest-api.html](Livy Documentation)

#### Enjoy! :)