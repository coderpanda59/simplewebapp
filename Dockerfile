# Use a lightweight Java image
# Use an official Maven image to build the project
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app
COPY . /app

# Build the project (creates target/app.jar)
RUN mvn clean package -DskipTests

# Use an OpenJDK image to run the application
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the built JAR from the previous stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8081

# Run the application
CMD ["java", "-jar", "app.jar"]

