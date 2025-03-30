pipeline {
    agent any
    environment {
        SSH_USER = "ubuntu"
        SSH_HOST = "ec2-3-25-106-160.ap-southeast-2.compute.amazonaws.com"
        APP_DIR = "/home/ubuntu/app"
        DOCKER_IMAGE = "pandurang70/springboot-app:latest"
        CONTAINER_NAME = "springboot-app"
        REPO_URL = "https://github.com/coderpanda59/simplewebapp.git"
    }
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    if (fileExists('app')) {
                        echo 'Removing existing app directory...'
                        sh 'rm -rf app'
                    }
                    echo 'Cloning repository...'
                    sh "git clone -b main ${env.REPO_URL} app"
                }
            }
        }

        stage('Build Project') {
            steps {
                script {
                    echo 'Building Maven project...'
                    dir('app') {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                        usernameVariable: 'DOCKER_HUB_USERNAME', 
                        passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                    script {
                        echo 'Logging into Docker Hub...'
                        sh "docker login -u ${env.DOCKER_HUB_USERNAME} -p ${env.DOCKER_HUB_PASSWORD}"
                    }
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build -t ${env.DOCKER_IMAGE} app"
                    echo 'Tagging Docker image...'
                    sh "docker tag ${env.DOCKER_IMAGE} ${env.DOCKER_IMAGE}-backup"
                    echo 'Pushing Docker image to Docker Hub...'
                    sh "docker push ${env.DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu-aws', keyFileVariable: 'SSH_KEY_PATH')]) {
                    script {
                        echo 'Deploying Docker container to AWS EC2 instance...'
                        sh """
                        ssh -tt -o StrictHostKeyChecking=no -i ${env.SSH_KEY_PATH} ${env.SSH_USER}@${env.SSH_HOST} << 'EOF'
                        set -e;
                        CONTAINER_NAME="${env.CONTAINER_NAME}";
                        DOCKER_IMAGE="${env.DOCKER_IMAGE}";
                        if docker ps -a --format '{{.Names}}' | grep -wq "\$CONTAINER_NAME"; then
                            docker stop "\$CONTAINER_NAME";
                            docker rm "\$CONTAINER_NAME";
                        fi;
                        docker system prune -f;
                        docker pull "\$DOCKER_IMAGE";
                        docker run -d --name "\$CONTAINER_NAME" -p 8081:8081 "\$DOCKER_IMAGE";
                        EOF
                        """
                    }
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    echo 'Performing health check...'
                    sh """
                    HTTP_RESPONSE=\$(curl -s -o /dev/null -w "%{http_code}" http://${env.SSH_HOST}:8081)
                    if [ "\$HTTP_RESPONSE" -eq 200 ]; then
                        echo "Application is running successfully!"
                    else
                        echo "Application failed to start!" && exit 1
                    fi
                    """
                }
            }
        }
    }
}
