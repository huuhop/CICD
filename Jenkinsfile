pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nestjs-app'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_USER = 'huuhop1'
        DOCKER_PASS = '123456789Q!'
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
                    bat """
                        docker build -t %DOCKER_REGISTRY%/%DOCKER_USER%/%DOCKER_IMAGE%:%BUILD_NUMBER% .
                    """
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-5', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        bat """
                            echo "DOCKER_USER=%DOCKER_USER%"
                            echo "DOCKER_PASS=%DOCKER_PASS%"
                            echo %DOCKER_PASS% | docker login --username %DOCKER_USER% --password-stdin
                            echo 111111111
                            docker push %DOCKER_REGISTRY%/%DOCKER_USER%/%DOCKER_IMAGE%:%BUILD_NUMBER%
                        """
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    bat """
                        docker run -d -p 3000:3000 %DOCKER_REGISTRY%/%DOCKER_USER%/%DOCKER_IMAGE%:%BUILD_NUMBER%
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