    pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64' // Ensure it's correct
        MAVEN_HOME = 'C:\\apache-maven-3.9.9' // Ensure it's correct
        PATH = "${JAVA_HOME}\\bin;${MAVEN_HOME}\\bin;${env.PATH}"
        
        // AWS EC2 Details
        EC2_USER = 'ubuntu'  // Change to 'ec2-user' if using Amazon Linux
        EC2_IP = '3.25.50.162'  // Replace with your EC2 Public IP
        SSH_KEY = 'C:\\Users\\pmasu\\Downloads\\jenkins.pem' // Full path to your SSH private key
        REMOTE_TOMCAT_PATH = 'var/lib/tomcat10/webapps/' // Update based on your Tomcat setup
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    credentialsId: 'github-pat', 
                    url: 'https://github.com/coderpanda59/simplewebapp.git'
            }
        }

        stage('Build & Test') {
            steps {
                bat 'mvn clean package'
                bat 'mvn test'
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                echo 'Transferring WAR file to AWS EC2...'

                // Securely copy WAR file to EC2 using SCP
                bat "scp -i \"${SSH_KEY}\" target\\simplewebapp.war ${EC2_USER}@${EC2_IP}:${REMOTE_TOMCAT_PATH}"

                // Restart Tomcat on EC2
                bat "ssh -i \"${SSH_KEY}\" ${EC2_USER}@${EC2_IP} 'sudo systemctl restart tomcat'"
            }
        }
    }

    post {
        success {
            echo 'Deployment to AWS EC2 Successful!'
        }
        failure {
            echo 'Build or Deployment Failed!'
        }
    }
}

}