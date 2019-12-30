#!/bin/bash

REPOSITORY=/home/ec2-user/app/step1
PROJECT_NAME=springboot-webservice

cd $REPOSITORY/$PROJECT_NAME/

echo "> Git Pull"

git pull

echo "> 프로젝트 Build 시작"

./gradlew build

echo "> step1 디렉토리로 이동"

cd $REPOSITORY

echo "> Build 파일 복사"

cp $REPOSITORY/$PROJECT_NAME/build/libs/*.jar $REPOSITORY/

echo "> 현재 실행중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -fl springboot-webservice | grep jar | awk '{print $1}')

echo "현재 실행중인 애플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 실행중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo ">kill -15 $CURRENT_PID"
    kill -15 $CURRNET_PID
    sleep 5
fi

echo ">새 애플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/ | grep *.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

nohup java -jar \
    -Dspring.config.location=classpath:/application.properties,/home/ec2-user/app/application-oauth.properties \
    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &