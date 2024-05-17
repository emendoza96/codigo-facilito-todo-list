#!/usr/bin/env groovy

pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'emendoza96/app-todo-list'
        VERSION_TAG = 'latest'
        VERSION = 'latest'
        CONTAINER_ID = ''
    }

    stages {
        stage('Set prod version tag') {
            when {
                branch 'main'
            }
            steps {
                script {
                    versionTag = readFile 'version_prod.txt'
                    VERSION = versionTag.trim().toInteger() + 1
                    VERSION_TAG = "prod-v${VERSION}"
                    DOCKER_HUB_REPO = "${DOCKER_HUB_REPO}:${VERSION_TAG}"
                    echo DOCKER_HUB_REPO
                }
            }
        }

        stage('Set dev version tag') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    VERSION_TAG = "dev-v${BUILD_NUMBER}"
                    DOCKER_HUB_REPO = "${DOCKER_HUB_REPO}:${VERSION_TAG}"
                    echo DOCKER_HUB_REPO
                }
            }
        }

        stage('Verificar tools') {
            steps {
                sh 'docker info'
            }
        }

        stage('Build docker image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_REPO} ."
            }
        }

        stage('Run docker image') {
            steps {
                script {
                    CONTAINER_ID = sh(script: "docker run -dit ${DOCKER_HUB_REPO}", returnStdout: true).trim()
                }
            }
        }

        stage('Run specs') {
            steps {
                sh "docker exec ${CONTAINER_ID} sh -c \"npm test\""
            }
        }

        stage('Push prod to Docker Hub') {
            when {
                expression {
                    return env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'develop'
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh "docker push ${DOCKER_HUB_REPO}"
                }
            }
        }

        stage('Update version in repository') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                    sh 'git config user.email "emim7802@gmail.com"'
                    sh 'git config user.name "Emiliano Mendoza"'
                    sh "echo ${VERSION} > version_prod.txt"
                    sh 'git add version_prod.txt'
                    sh 'git commit -m "Update version prod"'
                    sh 'git push https://$GITHUB_TOKEN@github.com/emendoza96/codigo-facilito-todo-list.git HEAD:main'
                }
            }
        }
    }

    post {
        always {
            sh "docker stop ${CONTAINER_ID}"
            sh "docker rm ${CONTAINER_ID}"
            sh "docker rmi -f ${DOCKER_HUB_REPO}"
        }
    }
}