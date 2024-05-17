#!/usr/bin/env groovy

pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'emendoza96/app-todo-list'
        CONTAINER_NAME = 'app-todo-list'
    }

    stages {
        stage('Verificar tools') {
            steps {
                sh 'docker info'
            }
        }

        stage('Build docker image') {
            steps {
                sh 'docker build -t ${DOCKER_HUB_REPO} .'
            }
        }

        stage('Run docker image') {
            steps {
                sh 'docker run -dit --name ${CONTAINER_NAME} ${DOCKER_HUB_REPO}'
            }
        }

        stage('Run specs') {
            steps {
                sh 'docker exec ${CONTAINER_NAME} sh -c "npm test"'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push ${DOCKER_HUB_REPO}:v${BUILD_NUMBER}'
                }
            }
        }
    }

    post {
        always {
            sh 'docker stop ${CONTAINER_NAME}'
            sh 'docker rm ${CONTAINER_NAME}'
        }
    }
}