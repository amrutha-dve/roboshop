source common.sh
component=catalogue
NODEJS

PRINT install mongo client
dnf install mongodb-mongosh -y &>>$LOG_FILE
if [ $? -eq 0 ]; then
   echo SUCCESS
  else
    echo FAILURE
  fi

PRINT load master data
mongosh --host mongo.dev.devopsb72.online </app/db/master-data.js &>>$LOG _FILE
if [ $? -eq 0 ]; then
   echo SUCCESS
  else
    echo FAILURE
  fi