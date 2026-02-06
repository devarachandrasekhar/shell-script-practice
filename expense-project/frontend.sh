#!/bin/bash/

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
      echo -e "$2 ...$R FAILURE $N"
      exit 1
    else
      echo -e "$2 ...$G SUCCESS $N"
    fi    

}

CHECK_ROOT() {
    if [ $USERID -ne 0 ]
        then 
          echo "ERROR: You must have root access to execute this script"
          exit 1
    fi      

}

mkdir -p $LOGS_FOLDER

CHECK_ROOT

dnf install nginx -y &>>$LOG_FILE_NAME
VALIDATE $? " Installing Nginx server"

systemctl enable nginx &>>$LOG_FILE_NAME
VALIDATE $? " Enable Nginx server"

systemctl start nginx &>>$LOG_FILE_NAME
VALIDATE $? " Start Nginx server"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE_NAME
VALIDATE $? "Removing existing version of code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "Downloading Fronted Code"

cd /usr/share/nginx/html &>>$LOG_FILE_NAME
VALIDATE $? "Moving to HTML Directory"

unzip /tmp/frontend.zip &>>$LOG_FILE_NAME
VALIDATE $? "Unzipping the frontend code"

cp /home/ec2-user/shell-script-practice/expense-project/expense.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE_NAME
VALIDATE $? "Copying expense.conf"

systemctl restart nginx  &>>$LOG_FILE_NAME
VALIDATE $? "Restarting Nginx"