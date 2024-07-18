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
  curl -o /tmp/${commponent}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  STAT $?

  PRINT extract new content
  cd ${app_path}
  unzip /tmp/frontend.zip &>>$LOG_FILE
  STAT $?
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
 id roboshop &>>$LOG_FILE
 if [ $? -ne 0 ]; then
   useradd roboshop &>>$LOG_FILE
 fi
 STAT $?

 APP_PREREQ

 PRINT download NodeJS depedencies
 npm install &>>$LOG_FILE
 STAT $?

 PRINT Start Service
 systemctl daemon-reload &>>$LOG_FILE
 systemctl enable ${component} &>>$LOG_FILE
 systemctl restart ${component} &>>$LOG_FILE
 STAT $?
}