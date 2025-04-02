pipeline {
    agent any

    environment {
        JAVA_HOME = tool 'jdk17'  // Ensure 'jdk17' is configured in Jenkins
        MAVEN_HOME = tool 'maven' // Ensure 'maven' is configured in Jenkins
        TOMCAT_URL = 'http://3.25.70.223:9090/manager/text'
        TOMCAT_USER = 'admin'
        TOMCAT_PASSWORD = 'admin_password'
        WAR_FILE_NAME = 'simplewebapp.war'  // Replace with actual WAR file name
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm  // Jenkins will pull from the configured Git repo
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
                    def tomcatDeployUrl = "${TOMCAT_URL}/deploy?path=/simplewebapp&update=true"  // Replace "your-app-name"

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
