pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "pandurang70/springboot-app:latest"
        CONTAINER_NAME = "springboot-app"
        APP_PORT = "8081"  // Change this if needed
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
                cd app
                mvn clean package -DskipTests
                '''
            }
        }
        
        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', 
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
                cd app
                docker build -t $DOCKER_IMAGE .
                docker push $DOCKER_IMAGE
                '''
            }
        }

        stage('Deploy on AWS EC2') {
            steps {
                sh '''
                # Stop and remove existing container if running
                if docker ps -a --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
                    docker stop "$CONTAINER_NAME"
                    docker rm "$CONTAINER_NAME"
                fi

                # Remove old images to save space
                docker system prune -f

                # Pull the latest image
                docker pull "$DOCKER_IMAGE"

                # Run the container
                docker run -d --name "$CONTAINER_NAME" -p $APP_PORT:$APP_PORT "$DOCKER_IMAGE"
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                sleep 5  # Wait for the app to start
                if curl -s --head --request GET http://localhost:$APP_PORT | grep "200 OK" > /dev/null; then
                    echo "Application is running successfully!"
                else
                    echo "Application failed to start!" && exit 1
                fi
                '''
            }
        }
    }
}
