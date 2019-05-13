firewall() {
  ips=("192.168.1.0" "192.168.1.1")

  for ip in ${ips[*]}
  do
    echo $ip
    firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="'${ip}'" accept' --permanent
  done
  firewall-cmd --reload
}
