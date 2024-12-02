pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nestjs-app'
        DOCKER_REGISTRY = 'docker.io'
    }
    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/huuhop/CICD.git'
            }
        }
        stage('Check Docker') {
            steps {
                script {
                    bat 'docker info'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    bat """
                        docker build -t $DOCKER_REGISTRY/$DOCKER_IMAGE:$BUILD_NUMBER .
                    """
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-1', passwordVariable: '123456789Q!!!!', usernameVariable: 'daniel')]) {
                        bat """
                            echo  docker login
                            docker push $DOCKER_REGISTRY/$DOCKER_IMAGE:$BUILD_NUMBER
                        """
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    bat """
                        docker run -d -p 3000:3000 $DOCKER_REGISTRY/$DOCKER_IMAGE:$BUILD_NUMBER
                    """
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