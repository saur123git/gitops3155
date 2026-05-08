# Stage 1: Build the artifact using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build_stage
LABEL author="vprofile-project"

# Set the working directory
WORKDIR /app

# Copy the source code to the container
COPY . .

# Build the WAR file and skip tests for speed
RUN mvn clean install -DskipTests

# Stage 2: Deploy the artifact to Tomcat 10
# We use Tomcat 10.1 to support Jakarta EE (Servlet 5.0+)
FROM tomcat:10.1-jdk17-openjdk-slim

# Remove default Tomcat applications to keep the image clean
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the generated WAR file from the build stage
# Note: Ensure the path to your .war file matches your project structure
COPY --from=build_stage /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
