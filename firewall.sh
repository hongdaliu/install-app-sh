update() {
  # update firewall white list
  wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/servers.sh
  sleep 3s
  source ./servers.sh
  for server in ${servers[*]}
  do
    firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="'${server}'" accept' --permanent
  done
  
  echo "reload firewall..."
  firewall-cmd --reload
  firewall-cmd --list-all
}
