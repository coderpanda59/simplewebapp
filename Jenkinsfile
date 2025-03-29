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
                git url: 'https://github.com/coderpanda59/simplewebapp.git', 
                    branch: 'main', 
                    credentialsId: '020d4854-fb5a-4cae-b6be-3876a63dab70'
            }
        }
        
        stage('Build Project') {
            steps {
                bat "mvn clean package"
            }
        }
        
        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                        usernameVariable: 'DOCKER_HUB_USERNAME', 
                        passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                    bat """
                    docker login -u %DOCKER_HUB_USERNAME% -p %DOCKER_HUB_PASSWORD%
                    """
                }
            }
        }
        
        stage('Build & Push Docker Image') {
            steps {
                bat """
                docker build -t %DOCKER_IMAGE% .
                docker tag %DOCKER_IMAGE% %DOCKER_IMAGE%-backup
                docker push %DOCKER_IMAGE%
                """
            }
        }
        
        stage('Deploy to AWS EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu-aws', keyFileVariable: 'SSH_KEY_PATH')]) {
                    powershell """
                    ssh -o StrictHostKeyChecking=no -i $env:SSH_KEY_PATH $env:SSH_USER@$env:SSH_HOST << 'EOF'
                        docker stop $env:CONTAINER_NAME || true
                        docker rm $env:CONTAINER_NAME || true
                        docker system prune -f
                        docker pull $env:DOCKER_IMAGE || exit 1
                        docker run -d --name $env:CONTAINER_NAME -p 8081:8081 $env:DOCKER_IMAGE || exit 1
                    EOF
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                powershell """
                try {
                    $response = Invoke-WebRequest -Uri http://$env:SSH_HOST:8081 -UseBasicParsing
                    if ($response.StatusCode -ne 200) { exit 1 }
                } catch {
                    Write-Output 'Application failed to start'
                    exit 1
                }
                """
            }
        }
    }
}
