pipeline {
    agent any
    environment {
        SONAR_SCANNER_HOME = '/path/to/sonar-scanner' // Remplacez par le chemin réel
        PATH = "${SONAR_SCANNER_HOME}/bin:${env.PATH}" // Ajout au PATH
    }
    stages {
        stage('SonarQube Analysis') {
            steps {
                sh 'echo "PATH: $PATH"' // Vérifie si sonar-scanner est dans PATH
                sh 'sonar-scanner --version' // Vérifie si sonar-scanner est accessible
            }
        }
    }
}
