source common.sh
component=mysql

PRINT Start MySql service &>>$LOG_FILE
STAT $?

PRINT install mysql
 dnf install mysql-server -y &>>$LOG_FILE
 STAT $?

 PRINT restart mysql
 systemctl enable mysqld &>>$LOG_FILE
 systemctl restart mysqld &>>$LOG_FILE
 STAT $?

 PRINT setuo  mysql root passwoqd
 mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
 STAT $?
