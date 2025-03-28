pipeline {
    agent any

    environment {
        JAVA_HOME = 'C:\\Program Files\\Java\\jdk-17.0.12' // Ensure it's correct
        MAVEN_HOME = 'C:\\apache-maven-3.9.9' // Ensure it's correct
        CATALINA_HOME = 'C:\\Users\\pmasu\\Downloads\\apache-tomcat-9.0.102-windows-x64\\apache-tomcat-9.0.102' // Path to Tomcat
        PATH = "${JAVA_HOME}\\bin;${MAVEN_HOME}\\bin;${CATALINA_HOME}\\bin;${env.PATH}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    credentialsId: 'github-pat', 
                    url: 'https://github.com/coderpanda59/simplewebapp.git'
            }
        }

        stage('Build & Test') {
            steps {
                bat 'mvn clean package'
                bat 'mvn test'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying WAR file to Tomcat...'
                bat 'copy target\\simplewebapp.war %CATALINA_HOME%\\webapps\\'
                bat '%CATALINA_HOME%\\bin\\shutdown.bat' // Stop Tomcat
                bat '%CATALINA_HOME%\\bin\\startup.bat'  // Start Tomcat
            }
        }
    }

    post {
        success {
            echo 'Build and Deployment Successful!'
        }
        failure {
            echo 'Build Failed!'
        }
    }
}