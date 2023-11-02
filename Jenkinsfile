pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'hungvietlai/my-drawing-app' //your own image
        DOCKER_CREDENTIALS = 'DockerHubCredentials'  //ID from Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/hungvietlai/my-drawing-app.git', branch: 'main'
                sh 'ls -la' // List the contents of the directory to verify
            }
        }
        
        stage('Test'){
            steps {
                    echo 'Running tests in Docker container'
                    // Running commands inside a Docker container to list files in /app and root directory
                    sh 'docker run --rm -v /var/jenkins_home/workspace/my-drawing-app:/app -w /app node:14-alpine ls -la /app'
                    sh 'docker run --rm -v /var/jenkins_home/workspace/my-drawing-app:/app -w /app node:14-alpine ls -la /'
                    dir('/app'){
                        sh 'npm install'
                        sh 'npm test'
                    }
                    
            }   
        }
      
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}", '.')
                    } catch (Exception e) {
                        echo "Docker build failed: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        return // Exit the stage
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    try {
                        docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS}") {
                            docker.image("${DOCKER_IMAGE}:${env.BUILD_ID}").push()
                        }
                    } catch (Exception e) {
                        echo "Docker push failed: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        return // Exit the stage
                    }
                }
            }
        }
    }