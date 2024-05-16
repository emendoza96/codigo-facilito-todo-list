#!/usr/bin/env groovy

pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials'
        DOCKER_HUB_REPO = 'emendoza96/app-todo-list'
        DOCKER_IMAGE_TAG = "latest"
    }

    stages {
        stage('Verificar tools') {
            steps {
                sh 'docker info'
            }
        }

        stage('Build docker image') {
            steps {
                sh 'docker build -t app-todo-list .'
            }
        }

        stage('Run docker image') {
            steps {
                sh 'docker run -dit --name app-todo-list app-todo-list'
            }
        }

        stage('Run specs') {
            steps {
                sh 'docker exec app-todo-list sh -c "npm test"'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', env.DOCKER_HUB_CREDENTIALS) {
                        docker.image("${env.DOCKER_HUB_REPO}:${env.DOCKER_IMAGE_TAG}").push()
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker stop app-todo-list'
            sh 'docker rm app-todo-list'
        }
    }
}