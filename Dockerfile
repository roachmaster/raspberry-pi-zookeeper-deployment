FROM openjdk:8-jdk-alpine
ARG PKG_VERSION=3.6.3
ARG PKG_NAME=zookeeper-${PKG_VERSION}
ARG ZK_HOME=/opt/zookeeper
ARG ZK_CLIENT_PORT=2181

ENV PATH=$PATH:$ZK_HOME/bin \
    ZOO_LOG4J_PROP=INFO,CONSOLE \
    ZK_USER=zookeeper \
    ZK_HOME=${ZK_HOME}


RUN apk add --no-cache bash

RUN set -ex && \
    apk add --no-cache bash su-exec && \
    adduser -D -u 1000 -H -h ${ZK_HOME} ${ZK_USER} && \
    addgroup ${ZK_USER} root && \
    cd /tmp && \
    wget -q "https://downloads.apache.org/zookeeper/${PKG_NAME}/apache-${PKG_NAME}-bin.tar.gz" && \
    wget -q "https://downloads.apache.org/zookeeper/${PKG_NAME}/apache-${PKG_NAME}-bin.tar.gz.sha512" && \
    sha512sum -c apache-${PKG_NAME}-bin.tar.gz.sha512 && \
    tar -zxf apache-${PKG_NAME}-bin.tar.gz && \
    mkdir -m 0775 -p ${ZK_HOME}/bin ${ZK_HOME}/lib ${ZK_HOME}/conf ${ZK_HOME}/data ${ZK_HOME}/logs && \
    install -o 1000 -g 0 -m 775 "apache-${PKG_NAME}-bin/bin/"*.sh ${ZK_HOME}/bin && \
    install -o 1000 -g 0 -m 664 "apache-${PKG_NAME}-bin/lib/"*.jar ${ZK_HOME}/lib && \
    cp -v apache-${PKG_NAME}-bin/conf/* ${ZK_HOME}/conf && \
    mv -v ${ZK_HOME}/conf/zoo_sample.cfg ${ZK_HOME}/conf/zoo.cfg && \
    rm -rf apache-${PKG_NAME}-bin apache-${PKG_NAME}-bin.tar.gz apache-${PKG_NAME}-bin.tar.gz.sha512

RUN sed -i "/dataDir=/d" ${ZK_HOME}/conf/zoo.cfg && \
    echo "dataDir=/opt/zookeeper/data" >> ${ZK_HOME}/conf/zoo.cfg && \
    echo "server.1=zk-0.zk-hs:2888:3888" >> ${ZK_HOME}/conf/zoo.cfg && \
    echo "server.2=zk-1.zk-hs:2888:3888" >> ${ZK_HOME}/conf/zoo.cfg && \
    echo "server.3=zk-2.zk-hs:2888:3888" >> ${ZK_HOME}/conf/zoo.cfg && \
    cat ${ZK_HOME}/conf/zoo.cfg && \
    chown -R ${ZK_USER} ${ZK_HOME} && \
    ls ${ZK_HOME}/conf && \
    ls ${ZK_HOME}/bin && \
    ls ${ZK_HOME}/lib

# adding entrypoint and startup scripts
#COPY *.sh $ZK_HOME/bin/
#RUN chmod -x ${ZK_HOME}/bin/entrypoint.sh ${ZK_HOME}/bin/bootstrap.sh && \
#    chmod 777 ${ZK_HOME}/bin/entrypoint.sh ${ZK_HOME}/bin/bootstrap.sh

WORKDIR ${ZK_HOME}
#EXPOSE ${ZK_CLIENT_PORT} 2888 3888
#VOLUME ["${ZK_HOME}/data", "${ZK_HOME}/logs"]


#ENTRYPOINT ["tail", "-f", "/dev/null"]
#ENTRYPOINT ["entrypoint.sh"]
#CMD ["bootstrap.sh", "zkServer.sh", "start-foreground"]