pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "myapp:latest"
        CONTAINER_NAME = "myapp-container"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/coderpanda59/simplewebapp.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Stop Existing Container') {
            steps {
                script {
                    sh "docker stop $CONTAINER_NAME || true"
                    sh "docker rm $CONTAINER_NAME || true"
                }
            }
        }

        stage('Run New Container') {
            steps {
                sh 'docker run -d -p 8000:8000 --name $CONTAINER_NAME $DOCKER_IMAGE'
            }
        }
    }
}
