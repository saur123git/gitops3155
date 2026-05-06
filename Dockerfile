# Stage 1: Build the artifact
FROM maven:3.9.6-eclipse-temurin-11 AS build
COPY . .
RUN mvn clean install -DskipTests

# Stage 2: Deploy to Tomcat
FROM tomcat:9-jre11
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
