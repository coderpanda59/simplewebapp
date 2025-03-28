# Use a lightweight Java image
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/simplewebapp.war app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
