pipeline {
    agent any
    environment {
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
        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                    sh "echo \"$DOCKER_HUB_PASSWORD\" | docker login -u \"$DOCKER_HUB_USERNAME\" --password-stdin"
                }
            }
        }
        stage('Build & Push Docker Image') {
            steps {
                sh """
                docker build -t $DOCKER_IMAGE .
                docker push $DOCKER_IMAGE
                """
            }
        }
        stage('Deploy to AWS EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'jenkins-ssh-key', keyFileVariable: 'SSH_KEY_PATH')]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY_PATH $SSH_USER@$SSH_HOST <<EOF
                    docker login -u "$DOCKER_HUB_USERNAME" -p "$DOCKER_HUB_PASSWORD"
                    docker pull $DOCKER_IMAGE
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                    docker run -d --name $CONTAINER_NAME -p 8081:8081 $DOCKER_IMAGE
                    EOF
                    """
                }
            }
        }
        stage('Health Check') {
            steps {
                script {
                    sh "curl -f http://$SSH_HOST:8081 || echo 'Application failed to start'"
                }
            }
        }
    }
}
