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
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t $DOCKER_REGISTRY/$DOCKER_IMAGE:$BUILD_NUMBER .
                    """
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-1', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh """
                            echo \$DOCKER_PASS | docker login --username \$DOCKER_USER --password-stdin
                            docker push $DOCKER_REGISTRY/$DOCKER_IMAGE:$BUILD_NUMBER
                        """
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh """
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