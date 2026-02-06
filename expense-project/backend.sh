#!bin/bash/

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

dnf module disable nodejs -y &>>$LOG_FILE_NAME
validate $? "Disable default nodejs versions"

dnf module enable nodejs:20 -y &>>$LOG_FILE_NAME
validate $? "Enable nodejs:20 version"


dnf install nodejs -y &>>$LOG_FILE_NAME
validate $? "Installing NodeJS"

useradd expense &>>$LOG_FILE_NAME
validate $? "Adding expense user"

mkdir /app cd /app &>>$LOG_FILE_NAME
validate $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE_NAME
validate $? "Downloading Backend"


cd /app &>>$LOG_FILE_NAME
validate $? "Moving to app directory"

unzip /tmp/backend.zip &>>$LOG_FILE_NAME
validate $? "Unzip Backend"

npm install &>>$LOG_FILE_NAME
validate $? "Install npm"

cp /home/ec2-user/shell-script-practice/expense-project/backend.service /etc/systemd/system/backend.service &>>$LOG_FILE_NAME
validate $? "Copy backend.service"


#Preparing MYSQL Schema

dnf install mysql -y &>>$LOG_FILE_NAME
validate $? "Install Mysql"

mysql -h 172.31.26.145 -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE_NAME
validate $? "Setting up transactions schema and tables"


systemctl daemon-reload &>>$LOG_FILE_NAME
validate $? "Daemon reload"

systemctl enable backend &>>$LOG_FILE_NAME
validate $? "Enabling backend"

systemctl restart backend &>>$LOG_FILE_NAME
validate $? "Restarting backend"












