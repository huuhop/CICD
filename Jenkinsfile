pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nestjs-app'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_USER = 'huuhop1'  // Username là một giá trị cố định 
        // DOCKER_PASS được lấy từ Jenkins credentials
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
        stage('Deploy') {
            steps {
                script {
                    powershell '''
                        echo "Deploying Docker container"
                        docker run -d -p 3000:3000 "$env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER"
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