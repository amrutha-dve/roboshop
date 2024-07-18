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
  fi
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

 PRINT Copy Service File
 cp ${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
 STAT $?

 PRINT copy MongoDB repo File
 cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
 STAT $?

 PRINT adding Application User
 useradd roboshop &>>$LOG_FILE
 STAT $?

 PRINT Cleaning Old Content
 rm -rf /app &>>$LOG_FILE
 STAT $?

 PRINT creating App Directory
 mkdir /app &>>$LOG_FILE
 STAT $?

 PRINT downloading the app info
 curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
 STAT $?
 cd /app

 PRINT Extract the app content
 unzip /tmp/${component}.zip &>>$LOG_FILE
 STAT $?

 PRINT download NodeJS depedencies
 npm install &>>$LOG_FILE
 STAT $?

 PRINT Start Service
 systemctl daemon-reload &>>$LOG_FILE
 systemctl enable ${component} &>>$LOG_FILE
 systemctl restart ${component} &>>$LOG_FILE
 STAT $?
}