source common.sh
component=catalogue
NODEJS

echo install mongo client
dnf install mongodb-mongosh -y >$LOG_FILE

echo load master data
mongosh --host mongo.dev.devopsb72.online </app/db/master-data.js >$LOG_FILE