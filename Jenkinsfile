pipeline {
    agent any
    environment {
        BACKEND_DIR = '.'  // Répertoire du projet Node.js
        IMAGE_NAME = 'my-node-backend-image'  // Nom de l'image Docker du back-end
        SONAR_SERVER = 'SonarQube'  // Nom du serveur SonarQube configuré dans Jenkins
        SONAR_SCANNER_HOME = '/opt/sonar-scanner'  // Chemin vers SonarQube Scanner (mettez le chemin exact)
        PATH = "${SONAR_SCANNER_HOME}/bin:${env.PATH}"  // Ajoute sonar-scanner à la variable PATH
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

        stage('Install Jest and jest-junit') {
            steps {
                dir("${env.BACKEND_DIR}") {
                    script {
                        echo 'Installing Jest and jest-junit...'
                        sh 'npm install --save-dev jest jest-junit'
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir("${env.BACKEND_DIR}") {
                    script {
                        echo 'Running tests for back-end...'
                        sh 'npm run test -- --coverage --passWithNoTests'  // Ajout de l'option pour accepter l'absence de tests
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    dir("${env.BACKEND_DIR}") {
                        script {
                            echo 'Running SonarQube analysis...'
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
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {  // Timeout étendu à 1 heure
                    script {
                        def qualityGate = waitForQualityGate()  // Vérification sans boucle
                        echo "Quality Gate Status: ${qualityGate.status}"
                        if (qualityGate.status != 'OK') {
                            error "SonarQube Quality Gate failed: ${qualityGate.status}"
                        }
                    }
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
    }

    post {
        success {
            echo '✅ Back-end build, SonarQube analysis, and Docker image creation successful!'
        }
        failure {
            echo '❌ Back-end build, SonarQube analysis, or Docker image creation failed!'
        }
    }
}
