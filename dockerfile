FROM openjdk:8-jdk-alpine
ARG JAR_FILE
COPY ${JAR_FILE} odin.jar
ENTRYPOINT ["java", "-jar", "/odin.jar"] 