#!/bin/bash/


USERID=$(id -u)

if [ $USERID -ne 0 ]
  then

  echo "Error:Please run script with root access"
  exit 1
  else
  echo "Info:You are root user"

fi 


validate () {
if [ $1 -ne 0 ]

  then 
  echo "$1 failed $2"

  else
  echo "$2 installed succesfull"

fi  

}

yum install nginx -y

validate $? nginx

yum install git -y

validate $? git

validate $? mailx