#!/bin/bash

export zookeeperServer=("45.33.13.132" "72.14.191.98" "198.58.106.192")
export datacenterServer=("45.56.126.161" "45.33.0.93" "45.33.14.182")
export serviceServer=("45.79.26.254")
export localComputer=("123.132.248.222")

export allServers=(${zookeeperServer[*]} ${datacenterServer[*]} ${serviceServer[*]})
export whiteListServers=(${zookeeperServer[*]} ${datacenterServer[*]} ${serviceServer[*]} ${localComputer[*]})
