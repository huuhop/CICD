pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nestjs-app'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_USER = 'huuhop1'  // Username là một giá trị cố định 
        EC2_SERVER = '3.25.88.171'  // Địa chỉ IP EC2 của bạn
        EC2_USER = 'ec2-user'  // Người dùng trên EC2 (ví dụ: ec2-user hoặc ubuntu)
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
        stage('SSH AWS EC2') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-remote-2', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER'),
                                    usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            powershell '''
                                echo "Starting SSH connection to EC2"
                                
                                # Thiết lập quyền truy cập cho khóa SSH
                                icacls $env:SSH_KEY /inheritance:r
                                icacls $env:SSH_KEY /grant:r SYSTEM:F
                                icacls $env:SSH_KEY /grant:r "BUILTIN\\Administrators":F
                                
                                # Kết nối SSH và thực hiện pull + run Docker
                                ssh -o StrictHostKeyChecking=no -i $env:SSH_KEY $env:SSH_USER@$env:EC2_SERVER "
                                    docker login --username ${env:DOCKER_USER} --password ${env:DOCKER_PASS} &&
                                    docker pull ${env:DOCKER_REGISTRY}/${env:DOCKER_USER}/${env:DOCKER_IMAGE}:${env:BUILD_NUMBER} &&
                                    docker stop ${env:DOCKER_IMAGE} || true &&
                                    docker rm ${env:DOCKER_IMAGE} || true &&
                                    docker run -d --name ${env:DOCKER_IMAGE} -p 3000:3000 ${env:DOCKER_REGISTRY}/${env:DOCKER_USER}/${env:DOCKER_IMAGE}:${env:BUILD_NUMBER}
                                "
                            '''
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

// pipeline {
//     agent any
//     environment {
//         EC2_SERVER = '3.25.88.171'  // Địa chỉ IP EC2 của bạn
//     }
//     stages {
//         stage('Clone') {
//             steps {
//                 script {
//                     git 'https://github.com/huuhop/CICD.git'
//                 }
//             }
//         }
//         // stage('SSH AWS EC2') {
//         //     steps {
//         //         script {
//         //             withCredentials([sshUserPrivateKey(credentialsId: 'ssh-remote-2', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
//         //                 bat """
//         //                     echo Starting SSH connection to EC2
//         //                     REM Thiết lập quyền truy cập cho khóa SSH
//         //                     icacls $SSH_KEY /inheritance:r
//         //                     icacls $SSH_KEY /grant:r SYSTEM:F
//         //                     icacls $SSH_KEY /grant:r "BUILTIN\\Administrators":F
//         //                     REM Sử dụng ssh để kết nối với EC2 và tạo file text.txt
//         //                     ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@$EC2_SERVER touch text.txt
//         //                 """
//         //             }
//         //         }
//         //     }
//         // }
//         stage('SSH AWS EC2') {
//             steps {
//                 script {
//                     withCredentials([sshUserPrivateKey(credentialsId: 'ssh-remote-2', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER'),
//                                     usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
//                         powershell '''
//                             echo "Starting SSH connection to EC2"
                            
//                             # Thiết lập quyền truy cập cho khóa SSH
//                             icacls $env:SSH_KEY /inheritance:r
//                             icacls $env:SSH_KEY /grant:r SYSTEM:F
//                             icacls $env:SSH_KEY /grant:r "BUILTIN\\Administrators":F
                            
//                             # Kết nối SSH và thực hiện pull + run Docker
//                             ssh -o StrictHostKeyChecking=no -i $env:SSH_KEY $env:SSH_USER@$env:EC2_SERVER "
//                                 docker login --username $env:DOCKER_USER --password $env:DOCKER_PASS 
//                             "
//                         '''
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