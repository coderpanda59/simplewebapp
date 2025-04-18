# Use a lightweight Java image
# Use an official Maven image to build the project

# Build the project (creates target/app.jar)
#RUN mvn clean package -DskipTests

# Use an OpenJDK image to run the application
#FROM openjdk:17-jdk-slim
#WORKDIR /app

# Copy the built JAR from the previous stage
#COPY --from=build /app/target/*.war app.war

# Expose the application port
#EXPOSE 8081

# Run the application
#CMD ["java", "-jar", "app.war"]

# Stage 1: Build the WAR using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app
COPY . /app

# Package the WAR (skipping tests for speed)
RUN mvn clean package -DskipTests

# Stage 2: Use Apache Tomcat to run the WAR
FROM tomcat:9-jdk17-temurin

# Remove default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy and rename the WAR to ROOT.war so it's accessible at "/"
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]


