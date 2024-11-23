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
        IMAGE_REPO_NAME="devops/masterclass"
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

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile in the project root
                    // docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                    docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }

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
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }   
    }

    post {
        always {
            // Clean up any images or containers created by the build to save disk space
            script {
                try {
                    docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").remove()
                } catch (Exception e) {
                    echo "Failed to remove Docker image: ${e.getMessage()}"
                }
            }
        }
    }
}
