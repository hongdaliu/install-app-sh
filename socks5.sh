yum -y upgrade
sleep 5s

isJavaInstall=`yum list installed | grep java`
if [ ${#isJavaInstall} == 0 ]
then
  echo "installing java..."
  yum install -y java
  yum install -y java-1.8.0-openjdk-devel.x86_64

  echo 'export JAVA_HOME=/etc/alternatives/java_sdk_1.8.0_openjdk' >> ~/.bashrc
  echo 'export JRE_HOME=${JAVA_HOME}/jre' >> ~/.bashrc
  echo 'export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib' >> ~/.bashrc
  echo 'PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
  source ~/.bashrc
fi
isWgetInstall=`yum list installed | grep wget`
if [ ${#isWgetInstall} == 0 ]
then
  echo "installing wget..."
  yum install -y wget
fi
isDockerInstall=`yum list installed | grep docker`
if [ ${#isDockerInstall} == 0 ]
then
  echo "installing docker..."
  yum install -y docker
  sleep 5s
  systemctl start docker.service
  systemctl enable docker.service
  docker pull redis
  sleep 15s
  echo "waiting 15 seconds..."

  docker run --restart always --name redis -d -it -p 6379:6379 docker.io/redis
fi
netstat -plnet

echo "setting max open files..."
ulimit -n 65535
