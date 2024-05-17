#!/usr/bin/env groovy

pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'emendoza96/app-todo-list'
        CONTAINER_NAME = 'app-todo-list'
        VERSION_TAG = ''
        VERSION = ''
    }

    stages {
        stage('Set Version Tag') {
            steps {
                script {
                    versionTag = readFile 'version_prod.txt'
                    VERSION_TAG = (versionTag.toInteger() + 1).toString()
                }
            }
        }

        stage('Output') {
            steps {
                script {
                    echo VERSION_TAG
                }
            }
        }

        stage('Verificar tools') {
            steps {
                sh 'docker info'
                sh 'echo ${VERSION_TAG}'
            }
        }

        // stage('Build docker image') {
        //     steps {
        //         sh 'docker build -t ${DOCKER_HUB_REPO} .'
        //     }
        // }

        // stage('Run docker image') {
        //     steps {
        //         sh 'docker run -dit --name ${CONTAINER_NAME} ${DOCKER_HUB_REPO}'
        //     }
        // }

        // stage('Run specs') {
        //     steps {
        //         sh 'docker exec ${CONTAINER_NAME} sh -c "npm test"'
        //     }
        // }

        // stage('Push prod to Docker Hub') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
        //             sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
        //             sh "docker tag ${DOCKER_HUB_REPO} ${DOCKER_HUB_REPO}:${VERSION_TAG}"
        //             sh 'docker push ${DOCKER_HUB_REPO}:${VERSION_TAG}'
        //         }

        //         withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
        //             sh '''
        //                 git config user.email "emim7802@gmail.com"
        //                 git config user.name "Emiliano Mendoza"
        //                 echo "${VERSION}" > version_prod.txt
        //                 git add version_prod.txt
        //                 git commit -m "Update version prod"
        //                 git push https://${GITHUB_TOKEN}@github.com/emendoza96/codigo-facilito-todo-list.git HEAD:main
        //             '''
        //         }
        //     }
        // }
    }

    post {
        always {
            sh 'docker stop ${CONTAINER_NAME}'
            sh 'docker rm ${CONTAINER_NAME}'
            sh "docker rmi -f ${DOCKER_HUB_REPO}:latest"
            sh "docker rmi -f ${DOCKER_HUB_REPO}:${VERSION_TAG}"
        }
    }
}