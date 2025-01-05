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
                        sh 'npm install'
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                dir("${env.BACKEND_DIR}") {
                    script {
                        echo 'Running tests for back-end...'
                        sh 'npm run test -- --coverage'
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
                        -Dsonar.projectName="Node Backend App" \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=. \
                        -Dsonar.sourceEncoding=UTF-8 \
                        -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
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
                    sh "docker build -t ${IMAGE_NAME} ${BACKEND_DIR}"
                }
            }
        }
        
        stage('Push Docker Image to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    script {
                        echo 'Pushing Docker image to Nexus...'
                        sh '''
                        docker tag ${IMAGE_NAME} <nexus-repo-url>:<port>/<repository-name>:latest
                        docker login <nexus-repo-url>:<port> -u ${NEXUS_USER} -p ${NEXUS_PASS}
                        docker push <nexus-repo-url>:<port>/<repository-name>:latest
                        '''
                    }
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

