pipeline {
    agent any
    environment {
        BACKEND_DIR = '.'  // Répertoire du projet Node.js
        IMAGE_NAME = 'my-node-backend-image'  // Nom de l'image Docker du back-end
        SONAR_SERVER = 'SonarQube'  // Nom du serveur SonarQube configuré dans Jenkins
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm  // Récupérer le code source depuis GitHub
            }
        }
        
        stage('Install Dependencies') {
            steps {
                dir("${env.BACKEND_DIR}") {
                    script {
                        echo 'Installing dependencies for back-end...'
                        sh 'npm install'  // Installer les dépendances via npm
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                dir("${env.BACKEND_DIR}") {
                    script {
                        echo 'Running tests for back-end...'
                        sh 'npm run test -- --coverage'  // Exécuter les tests avec couverture
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    dir("${env.BACKEND_DIR}") {
                        sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=node-backend-app \
                        -Dsonar.projectName=Node Backend App \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=. \
                        -Dsonar.language=js \
                        -Dsonar.sourceEncoding=UTF-8 \
                        -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
                        -Dsonar.host.url=http://<adresse-sonarqube>:9000 \
                        -Dsonar.token=<your-token>
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Build Docker Image for Back-end') {
            steps {
                script {
                    echo 'Building Docker image for back-end...'
                    sh "docker build -t ${IMAGE_NAME} ${BACKEND_DIR}"  // Construire l'image Docker
                }
            }
        }
        
        stage('Push Docker Image to Nexus') {
            steps {
                script {
                    echo 'Pushing Docker image to Nexus...'
                    sh '''
                    docker tag ${IMAGE_NAME} <nexus-repo-url>:<port>/<repository-name>:latest
                    docker login <nexus-repo-url>:<port> -u <username> -p <password>
                    docker push <nexus-repo-url>:<port>/<repository-name>:latest
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Back-end build, SonarQube analysis, and Docker image creation/push successful!'
        }
        failure {
            echo '❌ Back-end build, SonarQube analysis, or Docker image creation/push failed!'
        }
    }
}

