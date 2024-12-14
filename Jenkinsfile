pipeline {
    agent any

    // environment {
    //     // Set up environment variables for your image repository and tag
    //     DOCKER_IMAGE = 'gregatemi/jaythree'  // Replace with your Docker Hub repo
    //     IMAGE_TAG = "jenkins" // Could also use git commit hash for versioning, e.g., "${GIT_COMMIT}"
    //     DOCKER_CREDENTIALS_ID = 'DOCKER_CREDENTIALS_ID'
    // }

    environment {
        AWS_ACCOUNT_ID="682033467553"
        AWS_DEFAULT_REGION="eu-central-1" 
        IMAGE_REPO_NAME="jaythree"
        IMAGE_TAG="latest"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Check out code from the GitHub repository
                checkout scm
            }
        }

        stage('Logging into AWS ECR') {
            steps {
                script {
                    sh """aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                }  
            }
        }

        stage('Building image') {
            steps {
                script {
                    sh """ docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."""
                    sh """ docker build -t ${IMAGE_REPO_NAME}:${BUILD_ID} ."""
                }
            }
        }

        // stage('Build Docker Image') {
        //     steps {
        //         script {
        //             // Build the Docker image using the Dockerfile in the project root
        //             // docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
        //             docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        //         }
        //     }
        // }

        // stage('Push Docker Image') {
        //     when {
        //         expression { return env.DOCKER_CREDENTIALS_ID }
        //     }
        //     steps {
        //         script {
        //             // Log in to the Docker registry using the credentials ID
        //             docker.withRegistry('https://index.docker.io/v1/', 'DOCKER_CREDENTIALS_ID') {
        //                 // Push the Docker image
        //                 docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push()
        //             }
        //         }
        //     }
        // }

        // Uploading Docker images into AWS ECR
        stage('Pushing to ECR') {
            steps{ 
                script {
                    sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                    sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$BUILD_ID"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${BUILD_ID}"
                }
            }
        }

        // Removing redundant containers
        stage('Removing redundant containers') {
            steps{ 
                script {
                    sh "docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${BUILD_ID}"
                }
            }
        }

        stage('Update EKS Deployment') {
            steps {
                script {
                    // Configure kubectl to access your EKS cluster
                    sh "aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}"
                    
                    // Update the Kubernetes deployment with the new image
                    sh "kubectl set image deployment/jaythree -n jaythree jaythree=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_URI}:$IMAGE_TAG"
                }
            }
    }
}
