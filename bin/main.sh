#!/bin/bash

command="install"
app=""
pid=1
servers=""

. ./apps/init.sh
init

while getopts "c:a:" opt
do
  case $opt in
    c)
      command=${OPTARG}
      ;;
    a)
      app=${OPTARG}
      ;;
    *)
      help
      exit
      ;;
  esac
done

echo "begin ${command} ${app}..."