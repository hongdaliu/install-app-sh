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

isNtpInstall=`yum list installed | grep npt`
if [ ${#isNtpInstall} == 0 ]
then
  echo "installing npt..."
  yum -y install ntp
  systemctl start ntpd
  systemctl enable ntpd
fi

# update firewall white list
source servers.sh
for server in ${servers[*]}
do
  firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="'${server}'" accept' --permanent
done
firewall-cmd --reload
firewall-cmd --list-all
echo "firewall reload success"