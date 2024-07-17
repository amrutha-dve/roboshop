source common.sh
component=catalogue
NODEJS

PRINT install mongo client
dnf install mongodb-mongosh -y &>>$LOG_FILE

PRINT load master data
mongosh --host mongo.dev.devopsb72.online </app/db/master-data.js &>>$LOG _FILE