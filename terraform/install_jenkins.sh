#!/bin/bash

sudo apt update -y
sudo apt-get -y install openjdk-17-jre
sudo apt install -y docker
sudo apt install -y docker.io

sudo usermod -aG docker $USER


sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y jenkins

sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

exit