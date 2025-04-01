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
                script {
                    // Enable BuildKit if desired
                    sh 'export DOCKER_BUILDKIT=1'
                    // Using docker buildx with correct flag '--tag' instead of '-t'
                    sh 'docker buildx build --tag $DOCKER_IMAGE .'
                }
            }
        }

        stage('Stop Existing Container') {
            steps {
                script {
                    // Stop the existing container if it's running
                    sh "docker stop $CONTAINER_NAME || true"
                    // Remove the container to ensure a clean start
                    sh "docker rm $CONTAINER_NAME || true"
                }
            }
        }

        stage('Run New Container') {
            steps {
                script {
                    // Run the container in detached mode with port mapping
                    sh 'docker run -d -p 8000:8000 --name $CONTAINER_NAME $DOCKER_IMAGE'
                }
            }
        }
    }

    post {
        always {
            // Clean up: Ensure Docker containers are removed after each build
            sh "docker system prune -f"
        }
    }
}
