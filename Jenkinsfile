pipeline {
    agent any
    environment {
        SSH_USER = "ubuntu"
        SSH_HOST = "ec2-13-239-222-241.ap-southeast-2.compute.amazonaws.com"
        APP_DIR = "/home/ubuntu/app"
        DOCKER_IMAGE = "pandurang70/springboot-app:latest"
        CONTAINER_NAME = "springboot-app"
    }
    stages {
        stage('Clone Repository') {
            steps {
                sh '''
                if [ -d "app" ]; then
                    rm -rf app
                fi
                git clone -b main https://github.com/coderpanda59/simplewebapp.git app
                cd app
                '''
            }
        }
        
        stage('Build Project') {
            steps {
                sh '''
                mvn clean package
                '''
            }
        }
        
        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                        usernameVariable: 'DOCKER_HUB_USERNAME', 
                        passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                    sh '''
                    echo "$DOCKER_HUB_PASSWORD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
                    '''
                }
            }
        }
        
        stage('Build & Push Docker Image') {
            steps {
                sh '''
                docker build -t $DOCKER_IMAGE .
                docker tag $DOCKER_IMAGE $DOCKER_IMAGE-backup
                docker push $DOCKER_IMAGE
                '''
            }
        }
        
        stage('Deploy to AWS EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu-aws', keyFileVariable: 'SSH_KEY_PATH')]) {
                    sh '''
                    ssh -tt -o StrictHostKeyChecking=no -i $SSH_KEY_PATH $SSH_USER@$SSH_HOST << 'EOF'
                    CONTAINER_NAME="$CONTAINER_NAME"
                    DOCKER_IMAGE="$DOCKER_IMAGE"
                    
                    echo 'Checking if container exists...'
                    if docker ps -a --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
                        echo 'Stopping and removing existing container...'
                        docker stop "$CONTAINER_NAME"
                        docker rm "$CONTAINER_NAME"
                    fi
                    
                    echo 'Cleaning up Docker system...'
                    docker system prune -f
                    
                    echo 'Pulling latest Docker image: $DOCKER_IMAGE'
                    docker pull "$DOCKER_IMAGE"
                    
                    echo 'Running new container on port 9090'
                    docker run -d --name "$CONTAINER_NAME" -p 9090:9090 "$DOCKER_IMAGE"
                    EOF
                    '''
                }
            }
        }
        
        stage('Health Check') {
            steps {
                sh '''
                sleep 10
                if curl -s --head --request GET http://$SSH_HOST:9090 | grep "200 OK" > /dev/null; then 
                    echo "Application is running successfully!"
                else 
                    echo "Application failed to start!" >&2
                    exit 1
                fi
                '''
            }
        }
    }
}
