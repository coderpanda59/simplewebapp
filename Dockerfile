# Use a lightweight Java image
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/*.war app.jar
EXPOSE 8081
CMD ["java", "-jar", "app.jar"]
