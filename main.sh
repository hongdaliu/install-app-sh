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
wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/servers.sh
sleep 3s

if [ ${command} == "init" ]
then
  for server in ${servers[*]}
  do
    echo ${server}
    ssh ${server} 'wget ; sh init.sh; sleep 5s; rm -rf servers.sh; rm -rf init.sh'
  done
  echo "finished!!!"
fi

if [ ${command} == "install" ]
then
  wget "https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/"$option".sh"
  sleep 3s
  source $option".sh"
  install
  sleep 3s
  rm -rf $option".sh"
  echo "finished!!!"
fi

rm -rf servers.sh
