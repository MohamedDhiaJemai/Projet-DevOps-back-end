pipeline {
    agent any
    environment {
        SONAR_SERVER = 'SonarQube'  // Nom du serveur SonarQube configuré dans Jenkins
        SONAR_SCANNER_HOME = '/path/to/sonar-scanner'  // Chemin vers SonarQube Scanner
        PATH = "${SONAR_SCANNER_HOME}/bin:${env.PATH}"  // Ajoute sonar-scanner à la variable PATH
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm  // Récupérer le code source depuis GitHub
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    script {
                        echo 'Starting SonarQube analysis...'
                        sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=test-project \
                        -Dsonar.projectName="Test Project" \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=. \
                        -Dsonar.sourceEncoding=UTF-8
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ SonarQube analysis completed successfully!'
        }
        failure {
            echo '❌ SonarQube analysis failed!'
        }
    }
}
