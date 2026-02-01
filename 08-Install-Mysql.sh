#!/bin/bash/

yum install mysql -y

if [ $? -ne 0 ]
  then
  echo "installation of mysql is error"

  else
  echo "Installation of mysql is success"

fi  