LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
#PRINT() {
# echo &>>LOG_FILE
  #echo &>>LOG_FILE
  #echo "####################  $*  ###############" &>>LOG_FILE
  #echo $*
#$}
NODEJS() {
 echo Disable NodeJS Default Version
 dnf module disable nodejs -y >$LOG_FILE
 echo enable NodeJS 20 Module
 dnf module enable nodejs:20 -y >$LOG_FILE

 echo Install NodeJS
 dnf install nodejs -y >$LOG_FILE

 echo Copy Service File
 cp ${component}.service /etc/systemd/system/${component}.service >$LOG_FILE

 echo copy MongoDB repo File
 cp mongo.repo /etc/yum.repos.d/mongo.repo >$LOG_FILE

 echo adding Application User
 useradd roboshop >$LOG_FILE

 echo Cleaning Old Content
 rm -rf /app >$LOG_FILE

 echo creating App Directory
 mkdir /app >$LOG_FILE

echo downloading the app info
 curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/ca${component}-v3.zip >$LOG_FILE
 cd /app

echo Extract the app content
 unzip /tmp/${component}.zip >$LOG_FILE

echo download NodeJS depedencies
 npm install >$LOG_FILE

 echo Start Service
 systemctl daemon-reload >$LOG_FILE
 systemctl enable ${component} >$LOG_FILE
 systemctl restart ${component} >$LOG_FILE
}
