# Stage 1: Build the artifact
FROM maven:3.9.6-eclipse-temurin-17 AS build
COPY . .
RUN mvn clean install -DskipTests

# Stage 2: Deploy to Tomcat
# Use 'jdk17' or 'jr17' from the correct official image name
FROM tomcat:9.0-jdk17-temurin

# Remove default tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the artifact from the build stage
# Ensure the name matches your pom.xml (usually vprofile-v2.war or similar)
COPY --from=build target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
