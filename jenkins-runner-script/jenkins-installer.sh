#!/bin/bash
# Update the package index
sudo apt-get update -y

# Install Java (Jenkins requirement)
sudo apt-get install -y openjdk-11-jdk-headless

# Add Jenkins Repository and Key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt-get update -y
sudo apt-get install -y jenkins

# Install Terraform (Fixed for 64-bit architecture)
sudo apt-get install -y unzip
wget https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_amd64.zip
unzip terraform_1.6.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Clean up
rm terraform_1.6.5_linux_amd64.zip