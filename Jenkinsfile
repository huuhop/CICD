pipeline {
    agent any  // Chạy pipeline trên bất kỳ agent nào

    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/huuhop/CICD.git'
            }
        }
    }
}
