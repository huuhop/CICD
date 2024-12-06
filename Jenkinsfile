// pipeline {
//     agent any
//     environment {
//         DOCKER_IMAGE = 'nestjs-app'
//         DOCKER_REGISTRY = 'docker.io'
//         DOCKER_USER = 'huuhop1'  // Username là một giá trị cố định 
//         EC2_SERVER = '3.25.88.171'  // Địa chỉ IP EC2 của bạn
//         EC2_USER = 'ec2-user'  // Người dùng trên EC2 (ví dụ: ec2-user hoặc ubuntu)
//     }
//     stages {
//         stage('Clone') {
//             steps {
//                 script {
//                     git 'https://github.com/huuhop/CICD.git'  
//                 }
//             }
//         }
//         // stage('Build Docker Image') {
//         //     steps {
//         //         script {
//         //             powershell '''
//         //                 echo "Building Docker image for $env:DOCKER_IMAGE"
//         //                 echo "DOCKER_REGISTRY: $env:DOCKER_REGISTRY"
//         //                 echo "DOCKER_USER: $env:DOCKER_USER"
//         //                 echo "BUILD_NUMBER: $env:BUILD_NUMBER"
//         //                 docker build -t "$env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER" .
//         //             '''
//         //         }
//         //     }
//         // }
//         // stage('Push Docker Image') {
//         //     steps {
//         //         script {
//         //             withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
//         //                 powershell '''
//         //                     echo "Logging in to Docker Hub"
//         //                     docker login --username $env:DOCKER_USER --password $env:DOCKER_PASS
//         //                     docker push "$env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER"
//         //                 '''
//         //             }
//         //         }
//         //     }
//         // }
//          stage('SSH AWS EC2') {
//             steps {
//                 sshagent(['ssh-remote']) {
//                     powershell """
//                         ssh -o StrictHostKeyChecking=no $env:EC2_USER@$env:EC2_SERVER touch text.txt
//                     """
//                 }
//             }
//         }
//         //  stage('Deploy to EC2') {
//         //     steps {
//         //         script {
//         //             powershell '''
//         //                 echo "SSH into EC2 and pull Docker image"
//         //                 # Kiểm tra kết nối SSH trước
//         //                 $sshTestCommand = "ssh -i $env:EC2_KEY_PATH $env:EC2_USER@$env:EC2_SERVER 'hostname'"
//         //                 echo "Testing SSH connection to EC2"
//         //                 $sshTestOutput = Invoke-Expression $sshTestCommand
//         //                 echo "SSH connection output: $sshTestOutput"
                        
//         //                 if ($sshTestOutput -like "*ip-*") {
//         //                     echo "SSH connection successful, proceeding with Docker pull"
//         //                     # Tiến hành kéo và chạy Docker
//         //                     $sshCommand = "ssh -i $env:EC2_KEY_PATH $env:EC2_USER@$env:EC2_SERVER 'docker pull $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER && docker run -d -p 3000:3000 $env:DOCKER_REGISTRY/$env:DOCKER_USER/$env:DOCKER_IMAGE:$env:BUILD_NUMBER'"
//         //                     Invoke-Expression $sshCommand
//         //                     echo "Docker pull and run command executed successfully"
//         //                 } else {
//         //                     echo "SSH connection failed, exiting deployment."
//         //                     exit 1
//         //                 }
//         //             '''
//         //         }
//         //     }
//         // }
//     }
//     post {
//         success {
//             echo 'Pipeline hoàn tất thành công!'
//         }
//         failure {
//             echo 'Pipeline gặp lỗi!'
//         }
//     }
// }

// pipeline {
//     agent any
//     environment {
//         EC2_SERVER = '3.25.88.171'  // Địa chỉ IP EC2 của bạn
//         EC2_USER = 'ec2-user'  // Người dùng trên EC2 (ví dụ: ec2-user hoặc ubuntu)
//     }
//     stages {
//         stage('Clone') {
//             steps {
//                 script {
//                     git 'https://github.com/huuhop/CICD.git'  
//                 }
//             }
//         }
//         stage('SSH AWS EC2') {
//             steps {
//                 sshagent(['ssh-remote']) {
//                     script {
//                         // Chạy lệnh SSH
//                         sh """
//                             ssh -o StrictHostKeyChecking=no -l $EC2_USER $EC2_SERVER touch text.txt
//                         """
//                     }
//                 }
//             }
//         }
//     }
//     post {
//         success {
//             echo 'Pipeline hoàn tất thành công!'
//         }
//         failure {
//             echo 'Pipeline gặp lỗi!'
//         }
//     }
// }

pipeline {
    agent any
    environment {
        EC2_SERVER = '3.25.88.171'  // Địa chỉ IP EC2 của bạn
    }
    stages {
        stage('Clone') {
            steps {
                script {
                    git 'https://github.com/huuhop/CICD.git'
                }
            }
        }
        stage('SSH AWS EC2') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-remote', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                        echo "Using SSH Key for: \$SSH_USER@$EC2_SERVER"
                        echo "$SSH_KEY"
                         echo "$SSH_USER"
                        // Kết nối và chạy lệnh trên EC2 (dùng PowerShell thay vì sh)
                        bat """
                            ssh -o StrictHostKeyChecking=no -i \$SSH_KEY \$SSH_USER@$EC2_SERVER 'touch text.txt'
                        """
                    }
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