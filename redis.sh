source common.sh
component=redis

PRINT disable redis
dnf module disable redis -y &>>$LOG_FILE
STAT $?

PRINT enable redis:7
dnf module enable redis:7 -y &>>$LOG_FILE
STAT $?

PRINT install redis
dnf install redis -y &>>$LOG_FILE
STAT $?

PRINT updtae redis
sed -i -e '/^bind/ s/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
STAT $?

PRINT restart redis service
systemctl enable redis &>>$LOG_FILE
systemctl restart redis &>>$LOG_FILE
STAT $?