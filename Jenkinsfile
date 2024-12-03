pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nestjs-app'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_USER = 'huuhop1' 
        DOCKER_PASS = '123456789Q!' // Đảm bảo rằng đây là mật khẩu thật trong Jenkins credentials
    }
    stages {
        stage('Clone') {
            steps {
                script {
                    // Clone repository using PowerShell
                    powershell '''
                        git clone https://github.com/huuhop/CICD.git
                    '''
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using PowerShell
                    powershell '''
                        docker build -t $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER .
                    '''
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-5', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        powershell '''
                            echo "Logging in to Docker Hub with username: $env:DOCKER_USER"
                            echo $env:DOCKER_PASS | docker login --username $env:DOCKER_USER --password-stdin
                            echo "Pushing Docker image $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER"
                            docker push $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER
                        '''
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Deploy Docker container using PowerShell
                    powershell '''
                        docker run -d -p 3000:3000 $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER
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