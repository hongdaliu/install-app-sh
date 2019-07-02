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
isDocker=`yum list installed | grep docker`
if [ ${#isWgetInstall} == 0 ]
then
  echo "installing wget..."
  yum install -y docker
fi
