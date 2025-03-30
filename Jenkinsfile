pipeline { 
    agent any
    environment {
        SSH_USER = "ubuntu"
        SSH_HOST = "ec2-54-66-184-101.ap-southeast-2.compute.amazonaws.com"
        APP_DIR = "/home/ubuntu/app"
        DOCKER_IMAGE = "pandurang70/springboot-app:latest"
        CONTAINER_NAME = "springboot-app"
    }
    stages {
        stage('Clone Repository') {
            steps {
                powershell '''
                 if (Test-Path "app") {
                Remove-Item -Recurse -Force "app"
           	 }
                git clone -b main https://github.com/coderpanda59/simplewebapp.git app
                cd app
                '''
            }
        }
        
        stage('Build Project') {
            steps {
                powershell '''
                mvn clean package
                '''
            }
        }
        
        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                        usernameVariable: 'DOCKER_HUB_USERNAME', 
                        passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                    powershell '''
                    docker login -u $env:DOCKER_HUB_USERNAME -p $env:DOCKER_HUB_PASSWORD
                    '''
                }
            }
        }
        
        stage('Build & Push Docker Image') {
            steps {
                powershell '''
                docker build -t $env:DOCKER_IMAGE .
                docker tag $env:DOCKER_IMAGE $env:DOCKER_IMAGE-backup
                docker push $env:DOCKER_IMAGE
                '''
            }
        }
//            ssh -o StrictHostKeyChecking=no -i $env:SSH_KEY_PATH $env:SSH_USER@$env:SSH_HOST `
//	            ssh -tt -o StrictHostKeyChecking=no -i C:/Users/pmasu/.ssh/jenkins.pem ubuntu@ec2-3-27-170-22.ap-southeast-2.compute.amazonaws.com "`
//		stage('Deploy to AWS EC2') {
//		    steps {
//		        withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu-aws', keyFileVariable: 'SSH_KEY_PATH')]) {
//		            script {
//		                def sshCommand = """
//		                    ssh -tt -o StrictHostKeyChecking=no -i "C:\\ProgramData\\Jenkins\\.ssh\\jenkins.pem" ubuntu@ec2-3-104-76-101.ap-southeast-2.compute.amazonaws.com << 'EOF'
//		                    
//		                    CONTAINER_NAME="${env.CONTAINER_NAME}";
//		                    DOCKER_IMAGE="${env.DOCKER_IMAGE}";
//		                    if docker ps -a --format '{{.Names}}' | grep -wq "\$CONTAINER_NAME"; then
//		                        docker stop "\$CONTAINER_NAME";
//		                        docker rm "\$CONTAINER_NAME";
//		                    fi;
//		                    docker system prune -f;
//		                    docker pull "\$DOCKER_IMAGE";
//		                    docker run -d --name "\$CONTAINER_NAME" -p 8081:8081 "\$DOCKER_IMAGE";
//		
//		                    EOF
//		                """
//		                sh sshCommand
//		            }
//		        }
//		    }
//		}

		stage('Deploy to AWS EC2') {
		    steps {
		        withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu-aws', keyFileVariable: 'SSH_KEY_PATH')]) {
		            script {
		                def sshCommand = """
		                ssh -tt -o StrictHostKeyChecking=no -i C:/ProgramData/Jenkins/.ssh/jenkins.pem ubuntu@ec2-54-66-184-101.ap-southeast-2.compute.amazonaws.com " 
		                echo 'Logging into Docker Hub...'
                        echo '${DOCKER_PASSWORD}' | docker login -u '${DOCKER_USERNAME}' --password-stdin
		                CONTAINER_NAME='springboot-app'; 
		                DOCKER_IMAGE='pandurang70/springboot-app:latest';
		
		                echo 'Checking if container exists...';
		                if docker ps -a --format '{{.Names}}' | grep -wq \$CONTAINER_NAME; then
		                    echo 'Stopping and removing existing container...';
		                    docker stop \$CONTAINER_NAME;
		                    docker rm \$CONTAINER_NAME;
		                fi;
		
		                echo 'Cleaning up Docker system...';
		                docker system prune -f;
		
		                echo 'Pulling latest Docker image: \$DOCKER_IMAGE';
		                docker pull \$DOCKER_IMAGE;
		
		                echo 'Running new container on port 9090';
		                docker run -d --name \$CONTAINER_NAME -p 9090:9090 \$DOCKER_IMAGE;
		                "
		                """
		
		              
		            }
		        }
		    }
		}




        stage('Health Check') {
            steps {
                powershell '''
                try {
                    $response = Invoke-WebRequest -Uri http://$env:SSH_HOST:8081 -UseBasicParsing
                    if ($response.StatusCode -eq 200) {
                        Write-Host "Application is running successfully!"
                    } else {
                        Write-Error "Application failed to start!"
                    }
                } catch {
                    Write-Error "Application failed to start!"
                }
                '''
            }
        }
    }
}
