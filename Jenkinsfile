#!/usr/bin/env groovy

pipeline {
    agent any

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
    }

    post {
        always {
            sh 'docker stop app-todo-list'
            sh 'docker rm app-todo-list'
        }
    }
}