#!/usr/bin/env groovy

pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'emendoza96/app-todo-list'
        VERSION_TAG = 'latest'
        VERSION = 'latest'
        CONTAINER_ID = ''
        KUBERNETES_IP = '44.220.152.65'
        ENV = ''
    }

    stages {
        stage('Set prod version tag') {
            when {
                branch 'main'
            }
            steps {
                script {
                    ENV = "prod"
                    versionTag = readFile 'version_prod.txt'
                    VERSION = versionTag.trim().toInteger() + 1
                    VERSION_TAG = "${ENV}-v${VERSION}"
                    DOCKER_HUB_REPO = "${DOCKER_HUB_REPO}:${VERSION_TAG}"
                }
            }
        }

        stage('Set dev version tag') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    ENV = "dev"
                    versionTag = readFile 'version_dev.txt'
                    VERSION = versionTag.trim().toInteger() + 1
                    VERSION_TAG = "${ENV}-v${VERSION}"
                    DOCKER_HUB_REPO = "${DOCKER_HUB_REPO}:${VERSION_TAG}"
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

        stage('Push to Docker Hub') {
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
                expression {
                    return env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'develop'
                }
            }
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                    sh 'git config user.email "emim7802@gmail.com"'
                    sh 'git config user.name "Emiliano Mendoza"'
                    sh "echo ${VERSION} > version_${ENV}.txt"
                    sh "sed -i \"s/image: emendoza96\\/app-todo-list:.*/image: emendoza96\\/app-todo-list:${VERSION_TAG}/\" manifests/deployment-${ENV}.yml"
                    sh "git add version_${ENV}.txt"
                    sh "git add manifests/deployment-${ENV}.yml"
                    sh "git commit -m 'Update version ${ENV}'"
                    sh 'git push https://$GITHUB_TOKEN@github.com/emendoza96/codigo-facilito-todo-list.git HEAD:main'
                }
            }
        }

        stage('Deploy to kubernetes') {
            when {
                branch 'main'
            }
            steps {
                sshagent(['ssh-key']) {
                    sh "scp -o StrictHostKeyChecking=no manifests/deployment-prod.yml deploy_minikube.sh ubuntu@${KUBERNETES_IP}:/home/ubuntu/"
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@${KUBERNETES_IP} 'bash /home/ubuntu/deploy_minikube.sh'"
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