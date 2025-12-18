variable "vpc_cidr" {
    type = string
    description = "The CIDR block range for VPC."
}

variable "vpc_name" {
    type = string
    description = "The Name for the VPC."
}

variable "cidr_public_subnet" {
    type = list(string)
    description = "The CIDR block range for your VPC public subnet (make sure it's not overlapping with other subnets CIDR range)"
}

variable "cidr_private_subnet" {
    type = list(string)
    description = "The CIDR block range for your VPC private subnet (make sure it's not overlapping with other subnets CIDR range)"
}

variable "ap_availability_zone" {
    type = list(string)
    description = "List of availability zone in your region where you have created your VPC."
}

output "dev_proj_1_vpc_id" {
    value = aws_vpc.dev_proj_1_vpc_ap_south_1.id
}

# VPC Setup
resource "aws_vpc" "dev_proj_1_vpc_ap_south_1" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
}

# Public Subnet Setup
resource "aws_subnet" "dev_proj_1_public_subnets" {
    count = length(var.cidr_public_subnet)
    vpc_id = aws_vpc.dev_proj_1_vpc_ap_south_1.id
    cidr_block = element(var.cidr_public_subnet, count.index)
    availability_zone = element(var.ap_availability_zone, count.index)

    tags = {
        Name = "dev-proj-public-subnet-${count.index + 1}" 
    }
}

# Private Subnet Setup
resource "aws_subnet" "dev_proj_1_private_subnets" {
    count = length(var.cidr_private_subnet)
    vpc_id = aws_vpc.dev_proj_1_vpc_ap_south_1.id
    cidr_block = element(var.cidr_private_subnet, count.index)
    availability_zone = element(var.ap_availability_zone, count.index)

    tags = {
        Name = "dev-proj-private-subnet-${count.index + 1}"
    }
}