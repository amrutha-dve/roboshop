dnf install mongodb-org -y
## updating repo file
cp mongo.repo /etc/yum.repos.d/mongo.repo
systemctl enable mongod
systemctl restart mongod