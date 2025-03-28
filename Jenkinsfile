pipeline {
    agent any
    environment {
        SSH_KEY = "/var/lib/jenkins/.ssh/jenkins.pem"
        SSH_USER = "ubuntu"
        SSH_HOST = "ec2-3-24-135-39.ap-southeast-2.compute.amazonaws.com"
        APP_DIR = "/home/ubuntu/app"
        DOCKER_IMAGE = "pandurang70/springboot-app:latest"
        CONTAINER_NAME = "springboot-app"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/coderpanda59/simplewebapp.git'
            }
        }
        stage('Build Project') {
            steps {
                sh "mvn clean package -DskipTests"
            }
        }
        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t \$DOCKER_IMAGE .
                docker tag \$DOCKER_IMAGE pandurang70/springboot-app:latest
                docker push pandurang70/springboot-app:latest
                """
            }
        }
        stage('Deploy to AWS EC2') {
            steps {
                script {
                    sh """
                    ssh -i \$SSH_KEY \$SSH_USER@\$SSH_HOST "
                    sudo docker pull pandurang70/springboot-app:latest;
                    sudo docker stop \$CONTAINER_NAME || true;
                    sudo docker rm \$CONTAINER_NAME || true;
                    sudo docker run -d --name \$CONTAINER_NAME -p 8081:8081 \$DOCKER_IMAGE;
                    "
                    """
                }
            }
        }
    }
}
