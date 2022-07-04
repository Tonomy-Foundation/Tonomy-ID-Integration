pipeline {
    agent {
        docker {
            image 'koalaman/shellcheck'
            args '-v ./:/var/repo'
        }
    }
    stages {
        stage('Lint') {
            steps {
                /var/repo/scripts/lint-in-container.sh
            }
        }
    }
}