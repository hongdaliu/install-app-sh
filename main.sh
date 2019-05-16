#!/bin/bash
# servers=("198.58.106.192" "72.14.191.98" "45.33.13.132" "45.33.14.182" "45.33.0.93" "45.79.23.242" "23.239.26.70")
command="init"
option="single"
while getopts "c:o:" opt
do
  case $opt in
    c)
      command=${OPTARG}
      ;;
    o)
      option=${OPTARG}
      ;;
    *)
      echo "please input right command!"
      exit
      ;;
  esac
done

echo "-------------------------------------------------"
echo "| begin exectue "$command"                      |"
echo "| operate servers "$option"                     |"
echo "-------------------------------------------------"
wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/servers.sh -O servers.sh
sleep 3s

if [ ${command} == "init" ]
then
  source ./servers.sh
  
  for server in ${servers[*]}
  do
    echo ${server}
    echo "check wget..."
    ssh ${server} "yum install -y wget"
    echo "running script..."
    ssh ${server} 'curl https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/init.sh | bash; sleep 3s; rm -rf servers.sh'
    # ssh ${server} 'wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/init.sh; sleep 3s; sh init.sh; sleep 5s; rm -rf servers.sh; rm -rf init.sh'
  done
  echo "finished!!!"
fi

if [ ${command} == "install" ]
then
  wget "https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/"$option".sh" -O "$option".sh
  sleep 3s
  source ./$option".sh"
  install
  sleep 3s
  rm -rf $option".sh"
  echo "finished!!!"
fi

if [ ${command} == "restart" ]
then
  if [ ${option} == "zookeeper" ]
  then
    zookeepers=("45.33.13.132" "72.14.191.98" "198.58.106.192")
    echo "restarting zookeepers..."
    for zookeeper in ${zookeepers[*]}
    do
      ssh ${zookeeper} 'zkServer.sh restart'
      sleep 3s
    done
  fi
  
  if [ ${option} == "datacenter" ]
  then
    timer=0
    datacenters=("45.56.126.161" "45.33.0.93" "45.33.14.182")
    echo "restarting zookeepers..."
    for datacenters in ${datacenters[*]}
    do
      if [ ${timer} == 0 ]
      then
        ssh ${zookeeper} 'stop-dfs.sh; stop-yarn.sh; sleep 3s; start-dfs.sh; start-yarn.sh; sleep 3s; stop-hbase.sh; sleep 3s; start-hbase.sh; sleep 3s; kafka-server-stop.sh; sleep 3s; kafka-server-start.sh -daemon /opt/kafka_2.12-2.2.0/config/server.properties; sleep 3s; kafka-manager -Dhttp.port=8080 -Dconfig.file=/opt/kafka-manager-2.0.0.2/conf/application.conf'
      else
        ssh ${zookeeper} 'kafka-server-stop.sh; sleep 3s; kafka-server-start.sh -daemon /opt/kafka_2.12-2.2.0/config/server.properties; sleep 3s; kafka-manager -Dhttp.port=8080 -Dconfig.file=/opt/kafka-manager-2.0.0.2/conf/application.conf'
        sleep 3s
      fi
      timer=`expr $timer + 1`
    done
  fi
  echo "restart finished!!!"
fi
