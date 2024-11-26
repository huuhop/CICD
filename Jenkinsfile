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
                    // Build Docker image từ Dockerfile
                    sh 'docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Đăng nhập vào Docker registry (có thể cần credentials cho Docker Hub)
                    withCredentials([usernamePassword(credentialsId: '${DOCKER_CREDENTIALSID}', passwordVariable: '${DOCKER_PASS}', usernameVariable: '${DOCKER_USER}')]) {
                        sh '''
                            echo $DOCKER_PASS | docker login --username $DOCKER_USER --password-stdin
                            docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
         stage('Deploy') {
            steps {
                script {
                    // Chạy Docker container để triển khai ứng dụng
                    sh '''
                        docker run -d -p 3000:3000 ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    '''
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
        // stage('Build Stage') {
        //     steps {
        //          // This step should not normally be used in your script. Consult the inline help for details.
        //         withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') {
        //         }
        //     }
        // }
    }
}
