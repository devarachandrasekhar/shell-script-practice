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


dnf install mysql-server -y &>>$LOG_FILE_NAME
validate $? "Installing Mysql"

systemctl enable mysqld &>>$LOG_FILE_NAME
validate $? "Enable mysqld"

systemctl start mysqld &>>$LOG_FILE_NAME
validate $? "Start mysqld"


mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE_NAME
validate $? "Changed Default Password"
