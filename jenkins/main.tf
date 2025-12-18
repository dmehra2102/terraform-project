variable "ami_id" {
  type        = string
  description = "AMI Id for EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "tag_name" {
  type        = string
  description = "Name tag for EC2 instance"
}

variable "public_key" {
  type        = string
  description = "Public key for EC2 key pair"
}

variable "subnet_id" {
  type        = string
  description = "VPC subnet ID for EC2 instance"
}

variable "sg_for_jenkins" {
  type        = list(string)
  description = "Security group IDs for Jenkins EC2"
}

variable "enable_public_ip_address" {
  type        = bool
  description = "Enable public IP assignment"
}

variable "user_data_install_jenkins" {
  type        = string
  description = "User data script to install Jenkins"
}

locals {
  key_name = "aws_ec2_terraform"
}

output "ssh_connection_string_for_ec2" {
  description = "SSH command to connect to Jenkins EC2"
  value       = "ssh -i ~/.ssh/${local.key_name} ubuntu@${aws_instance.jenkins_ec2_instance_ip.public_ip}"
}

output "jenkins_ec2_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = aws_instance.jenkins_ec2_instance_ip.id
}

output "jenkins_ec2_instance_public_ip" {
  description = "Public IP of Jenkins EC2 instance"
  value       = aws_instance.jenkins_ec2_instance_ip.public_ip
}

resource "aws_instance" "jenkins_ec2_instance_ip" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.jenkins_ec2_instance_public_key.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.sg_for_jenkins
  associate_public_ip_address = var.enable_public_ip_address
  user_data                   = var.user_data_install_jenkins

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = var.tag_name
  }

  depends_on = [aws_key_pair.jenkins_ec2_instance_public_key]
}

resource "aws_key_pair" "jenkins_ec2_instance_public_key" {
  key_name   = "aws_ec2_terraform"
  public_key = var.public_key
}