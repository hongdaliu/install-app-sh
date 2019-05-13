firewall() {
  ips=("198.58.106.192" "72.14.191.98" "45.33.13.132" "45.33.14.182" "45.33.0.93" "45.79.23.242" "23.239.26.70")

  for ip in ${ips[*]}
  do
    echo $ip
    firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="'${ip}'" accept' --permanent
  done
  firewall-cmd --reload
  echo "firewall reload success"
}
