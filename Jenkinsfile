pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nestjs-app'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_USER = 'huuhop1'  // Username là một giá trị cố định 
        EC2_SERVER = '3.25.88.171'  // Địa chỉ IP EC2 của bạn
        EC2_USER = 'ec2-user'  // Người dùng trên EC2 (ví dụ: ec2-user hoặc ubuntu)
        EC2_KEY_PATH = 'C:/Users/HuuHop/Downloads/first-deploy.pem'  // Đường dẫn đến private key của EC2 (Windows path)
    }
    stages {
        stage('Clone') {
            steps {
                script {
                    git 'https://github.com/huuhop/CICD.git'  
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    powershell '''
                        echo "Building Docker image for $env:DOCKER_IMAGE"
                        echo "DOCKER_REGISTRY: $env:DOCKER_REGISTRY"
                        echo "DOCKER_USER: $env:DOCKER_USER"
                        echo "BUILD_NUMBER: $env:BUILD_NUMBER"
                        docker build -t "$env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER" .
                    '''
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        powershell '''
                            echo "Logging in to Docker Hub"
                            docker login --username $env:DOCKER_USER --password $env:DOCKER_PASS
                            docker push "$env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER"
                        '''
                    }
                }
            }
        }
         stage('Deploy to EC2') {
            steps {
                script {
                    powershell '''
                        echo "SSH into EC2 and pull Docker image"
                        # Sử dụng PowerShell để chạy lệnh SSH và docker pull
                        $sshCommand = "ssh -i $env:EC2_KEY_PATH $env:EC2_USER@$env:EC2_SERVER `"docker pull $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER && docker run -d -p 3000:3000 $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER`""
                        Invoke-Expression $sshCommand
                    '''
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline hoàn tất thành công!'
        }
        failure {
            echo 'Pipeline gặp lỗi!'
        }
    }
}