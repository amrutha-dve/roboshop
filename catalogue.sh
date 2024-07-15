## updating service file
cp catalogue.service /etc/systemd/system/catalogue.service
## updating repo file
cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
useradd roboshop
rm -rf /app
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
cd /app
unzip /tmp/catalogue.zip

rm -rf /app
cd /app
npm install
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
dnf install mongodb-mongosh -y
mongosh --host localhost </app/db/master-data.js