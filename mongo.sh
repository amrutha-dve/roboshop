source common.sh
component=mongo

PRINT copying rep file
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
STAT $?

PRINT install mongodb
dnf install mongodb-org -y &>>$LOG_FILE
STAT $?


PRINT update mongodb
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
STAT $?

PRINT restart mongodb
systemctl enable mongod &>>$LOG_FILE
systemctl restart mongod &>>$LOG_FILE
STAT $?