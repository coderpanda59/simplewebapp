# Use a lightweight Java image
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/*.war app.jar
EXPOSE 8000
CMD ["java", "-jar", "app.jar"]
