LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
PRINT() {
 echo &>>$LOG_FILE
  echo &>>$LOG_FILE
  echo " ####################  $*  ############### " &>>$LOG_FILE
  echo $*
}
STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo
    echo "refer the log file for more info : log path : ${LOG_FILE}"
    exit $1
  fi
}
APP_PREREQ() {
  PRINT remove old content
  rm -rf ${app_path} &>>$LOG_FILE
  STAT $?

  PRINT create new App Directory
  mkdir ${app_path} &>>$LOG_FILE
  STAT $?

  PRINT download the app content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  STAT $?

  PRINT extract new content
  cd ${app_path}
  unzip /tmp/${component}.zip &>>$LOG_FILE
  STAT $?
}
SYSTEMD_SETUP() {
    PRINT Copy Service File
    cp ${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
    STAT $?

   PRINT Start Service
   systemctl daemon-reload &>>$LOG_FILE
   systemctl enable ${component} &>>$LOG_FILE
   systemctl restart ${component} &>>$LOG_FILE
   STAT $?
}
JAVA() {
  cp shipping.service /etc/systemd/system/shipping.service
  dnf install maven -y
  useradd roboshop
  rm -rf /app
  mkdir /app
  curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip
  cd /app
  unzip /tmp/shipping.zip

  cd /app
  mvn clean package
  mv target/shipping-1.0.jar shipping.jar

  dnf install mysql -y

  mysql -h mysql.dev.devopsb72.online -uroot -pRoboShop@1 < /app/db/schema.sql
  mysql -h mysql.dev.devopsb72.online -uroot -pRoboShop@1 < /app/db/master-data.sql
  mysql -h mysql.dev.devopsb72.online -uroot -pRoboShop@1 < /app/db/app-user.sql

  systemctl daemon-reload
  systemctl enable shipping
  systemctl restart shipping

}
NODEJS() {
 PRINT Disable NodeJS Default Version
 dnf  module disable nodejs -y &>>$LOG_FILE
 STAT $?
 PRINT enable NodeJS 20 Module
 dnf module enable nodejs:20 -y &>>$LOG_FILE
 STAT $?

 PRINT Install NodeJS
 dnf install nodejs -y &>>$LOG_FILE
 STAT $?

 PRINT copy MongoDB repo File
 cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
 STAT $?

 PRINT adding Application User
 id roboshop &>>$LOG_FILE
 if [ $? -ne 0 ]; then
   useradd roboshop &>>$LOG_FILE
 fi
 STAT $?

 APP_PREREQ

 PRINT download NodeJS depedencies
 npm install &>>$LOG_FILE
 STAT $?

}