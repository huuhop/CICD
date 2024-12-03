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
                    git 'https://github.com/huuhop/CICD.git'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    powershell '''
                        echo "Building Docker image for $env:DOCKER_IMAGE"
                        docker build -t $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER .
                    '''
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        powershell '''
                            echo "DOCKER_USER: $env:DOCKER_USER"
                            echo "DOCKER_PASS: $env:DOCKER_PASS"
                             echo "Logging in to Docker Hub"
                            echo "Logging in to Docker Hub"
                            echo $env:DOCKER_PASS | docker login --username $env:DOCKER_USER --password-stdin
                            docker push $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER
                        '''
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    powershell '''
                        echo "Deploying Docker container"
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