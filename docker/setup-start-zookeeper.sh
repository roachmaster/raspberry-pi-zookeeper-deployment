#!/bin/bash -e

echo $REPLICA_SET_NUM
echo $ZK_DATA_DIR
#update zoo config, create for loop to do the following based on env var
for (( i = 0; i < $REPLICA_SET_NUM; i++ ))
do
  j=$((i+1)) ;
  echo "server.${j}=zk-${i}.zk-hs:2888:3888";
  echo "server.${j}=zk-${i}.zk-hs:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
done

# set up cluster id based on statefulset number
ZK_SERVER_ID=$((${HOSTNAME##*-}+1))
echo "${ZK_SERVER_ID}" > "${ZK_DATA_DIR}/myid"

cat "${ZK_DATA_DIR}/myid"
cat /opt/zookeeper/conf/zoo.cfg
# run server
zkServer.sh start-foreground /opt/zookeeper/conf/zoo.cfg

