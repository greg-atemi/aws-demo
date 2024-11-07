pipeline {
    agent any

    environment {
        // Set up environment variables for your image repository and tag
        DOCKER_IMAGE = 'gregatemi/jaythree'  // Replace with your Docker Hub repo
        IMAGE_TAG = "jenkins" // Could also use git commit hash for versioning, e.g., "${GIT_COMMIT}"
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
                    docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            when {
                // Only push if credentials are set (optional)
                expression { return env.DOCKER_CREDENTIALS_ID }
            }
            steps {
                script {
                    // Log in to the Docker registry
                    docker.withRegistry('', env.DOCKER_CREDENTIALS_ID) {
                        // Push the Docker image
                        docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push()
                    }
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
