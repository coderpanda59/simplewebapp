pipeline {
    agent any
    environment {
        JAVA_HOME = tool 'jdk17'  // Make sure JDK 17 is configured in Jenkins
        MAVEN_HOME = tool 'maven' // Ensure Maven is configured in Jenkins
        TOMCAT_URL = 'http://localhost:9090/manager/text'
        TOMCAT_USER = 'admin'
        TOMCAT_PASSWORD = 'admin123'
        WAR_FILE_NAME = 'simplewebapp.war'
    }
    stages {
        stage('Clone Repository') {
            steps {
                checkout scm  // Jenkins will pull from the Git repository
            }
        }
        stage('Build') {
            steps {
                bat "${MAVEN_HOME}\\bin\\mvn clean package -DskipTests"
            }
        }
        stage('Test') {
            steps {
                bat "${MAVEN_HOME}\\bin\\mvn test"
            }
        }
        stage('Deploy to Tomcat') {
            steps {
                script {
                    def warFilePath = "target/${WAR_FILE_NAME}"
                    def tomcatDeployUrl = "${TOMCAT_URL}/deploy?path=/your-app-name&update=true"
                    if (fileExists(warFilePath)) {
                        bat """
                        curl -u ${TOMCAT_USER}:${TOMCAT_PASSWORD} -T ${warFilePath} "${tomcatDeployUrl}"
                        """
                    } else {
                        error "WAR file not found: ${warFilePath}"
                    }
                }
            }
        }
    }
}
