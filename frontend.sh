source common.sh
component=frontend

app_path=/usr/share/nginx/html

PRINT Disable nginx Default Version
dnf module disable nginx -y &>>$LOG_FILE
STAT $?

PRINT Enable nginx:1.24
dnf module enable nginx:1.24 -y &>>$LOG_FILE
STAT $?

PRINT install nginx
dnf install nginx -y &>>$LOG_FILE
STAT $?

PRINT updating config file
cp nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
STAT $?

APP_PREREQ

PRINT start service
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
STAT $?
