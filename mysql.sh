source common.sh
component=mysql

PRINT Install Mysql server
dnf install mysql-server -y &>>$LOG_FILE
STAT $?

PRINT restart MySql service
systemctl enable mysqld  &>>$LOG_FILE
systemctl restart mysqld  &>>$LOG_FILE
STAT $?

PRINT MySql password
mysql_secure_installation --set-root-pass RoboShop@1
STAT $?
