pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'  // Adjust path if needed
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    credentialsId: 'github-pat', 
                    url: 'https://github.com/coderpanda59/simplewebapp.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    def mvnHome = tool name: 'maven', type: 'maven'
                    sh "${mvnHome}/bin/mvn clean package"
                }
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying application..."
                // Add deployment steps (e.g., copying JAR/WAR file to the server)
                // sh 'scp target/*.jar user@server:/deploy/path'
            }
        }
    }

    post {
        success {
            echo "Build & Deployment Successful!"
        }
        failure {
            echo "Build Failed!"
        }
    }
}
