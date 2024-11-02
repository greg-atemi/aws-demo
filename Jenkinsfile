pipeline {
    agent any 

    stages {
        stage('Build') {
            steps {
                echo 'We will build here...'
                // Your build commands here
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                // Your test commands here
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                // Your deployment commands here
            }
        }
    }

    post {
        always {
            echo 'This will always run after the pipeline finishes.'
        }
        success {
            echo 'This will run only if the pipeline is successful.'
        }
        failure {
            echo 'This will run only if the pipeline fails.'
        }
    }
}
