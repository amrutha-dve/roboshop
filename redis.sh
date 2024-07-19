PRINT disable redis
dnf module disable redis -y
STAT $?

PRINT enable redis:7
dnf module enable redis:7 -y
STAT $?

PRINT install redis
dnf install redis -y
STAT $?

PRINT updtae redis
sed -i -e '/^bind/ s/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
STAT $?

PRINT restart redis service
systemctl enable redis
systemctl restart redis
STAT $?