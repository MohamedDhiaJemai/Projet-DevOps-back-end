pipeline {
    agent any
    environment {
       SONAR_SCANNER_HOME = '/opt/sonar-scanner'
    PATH = "${SONAR_SCANNER_HOME}/bin:${env.PATH}"
    }
    stages {
        stage('Check PATH') {
    steps {
        sh 'echo PATH: $PATH'
    }
}

        stage('SonarQube Analysis') {
            steps {
                sh 'echo "PATH: $PATH"' // Vérifie si sonar-scanner est dans PATH
                sh 'sonar-scanner --version' // Vérifie si sonar-scanner est accessible
            }
        }
    }
}
