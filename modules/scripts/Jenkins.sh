#!/bin/bash

sudo yum update -y
sudo yum install docker git curl -y
sudo amazon-linux-extras enable corretto8
sudo dnf install java-17-amazon-corretto -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install jenkins -y && sudo systemctl enable jenkins && sudo systemctl start jenkins