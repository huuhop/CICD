pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nestjs-app'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_USER = 'huuhop1'  // Username là một giá trị cố định
        // DOCKER_PASS 123456789Q! được lấy từ Jenkins credentials
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
                        echo "Building Docker image for $DOCKER_IMAGE"
                        docker build -t $DOCKER_REGISTRY/$DOCKER_USER/$DOCKER_IMAGE:$BUILD_NUMBER .
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
                            docker login --username $DOCKER_USER --password $DOCKER_PASS
                            docker push $DOCKER_REGISTRY/$DOCKER_USER/$DOCKER_IMAGE:$BUILD_NUMBER
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
                        docker run -d -p 3000:3000 $DOCKER_REGISTRY/$DOCKER_USER/$DOCKER_IMAGE:$BUILD_NUMBER
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