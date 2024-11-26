pipeline {
    agent any  // Chạy pipeline trên bất kỳ agent nào
    environment {
        DOCKER_IMAGE = 'nestjs-app'  // Tên Docker image
        DOCKER_REGISTRY = 'docker.io' // Docker registry (ví dụ: Docker Hub)
        DOCKER_PASS = '123456789Q!!!!'
        DOCKER_USER = 'daniel'
        DOCKER_CREDENTIALSID = 'docker-hub-1'
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
                    sh 'start /B docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER} .'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: '${DOCKER_CREDENTIALSID}', passwordVariable: '${DOCKER_PASS}', usernameVariable: '${DOCKER_USER}')]) {
                        sh '''
                            echo $DOCKER_PASS | docker login --username $DOCKER_USER --password-stdin
                            start /B docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
         stage('Deploy') {
            steps {
                script {
                    sh '''
                        start /B docker run -d -p 3000:3000 ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER}
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
