pipeline {
    agent any
    environment {
        BACKEND_DIR = '.'  // Répertoire du projet Node.js
        IMAGE_NAME = 'my-node-backend-image'  // Nom de l'image Docker du back-end
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
                        sh 'npm test'  // Exécuter les tests si présents
                    }
                }
            }
        }
        stage('Build Docker Image for Back-end') {
            steps {
                script {
                    echo 'Building Docker image for back-end...'
                    sh 'docker build -t ${env.IMAGE_NAME} ${env.BACKEND_DIR}'  // Construire l'image Docker
                }
            }
        }
    }
    post {
        success {
            echo 'Back-end build and Docker image creation successful!'
        }
        failure {
            echo 'Back-end build or Docker image creation failed!'
        }
    }
}

