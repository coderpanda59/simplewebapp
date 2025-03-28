pipeline {
    agent any

    environment {
        JAVA_HOME = 'C:\\Program Files\\Java\\jdk-17' // Ensure it's correct
        MAVEN_HOME = 'C:\\Program Files\\Apache\\Maven' // Ensure it's correct
        PATH = "${JAVA_HOME}\\bin;${MAVEN_HOME}\\bin;${env.PATH}"
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
                echo 'Deploying application...'
                bat 'java -jar target/simplewebapp-1.0-SNAPSHOT.jar' // Replace with actual JAR name
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
