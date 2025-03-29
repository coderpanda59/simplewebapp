pipeline {
    agent any
    environment {
        SSH_KEY = credentials('jenkins-ssh-key')  // Use Jenkins credentials for security
        SSH_USER = "ubuntu"
        SSH_HOST = "ec2-3-24-135-39.ap-southeast-2.compute.amazonaws.com"
        APP_DIR = "/home/ubuntu/app"
        DOCKER_IMAGE = "pandurang70/springboot-app:latest"
        CONTAINER_NAME = "springboot-app"
        DOCKER_HUB_USERNAME = credentials('pandurang70')
        DOCKER_HUB_PASSWORD = credentials('dckr_pat_qbiab33G-2ncPkvgb1rWPD2Cu3s')
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
                sh "echo \"$DOCKER_HUB_PASSWORD\" | docker login -u \"$DOCKER_HUB_USERNAME\" --password-stdin"
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
                script {
                    sh """
                    ssh -i $SSH_KEY $SSH_USER@$SSH_HOST <<EOF
                    sudo docker login -u \"$DOCKER_HUB_USERNAME\" -p \"$DOCKER_HUB_PASSWORD\"
                    sudo docker pull $DOCKER_IMAGE
                    sudo docker stop $CONTAINER_NAME || true
                    sudo docker rm $CONTAINER_NAME || true
                    sudo docker run -d --name $CONTAINER_NAME -p 8081:8081 $DOCKER_IMAGE
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
