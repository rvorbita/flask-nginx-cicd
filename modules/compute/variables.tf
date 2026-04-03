
# AMI ID
variable "ami_id" {
    description = "The AMI ID for EC2 Instance"
    type = string
    default = "ami-0be9cb9f67c8dabd6"
  
}

# Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t3.micro"
}


# Subnet ID placeholder / variable
variable "subnet_id" {
    description = "The Subnet ID for EC2 Instance"
    type = string
    default = ""
}

# Security Group ID / variable
variable "security_group_id" {
    description = "The Security Group ID for EC2 Instance"
    type = string
    default = ""
  
}

# Region
variable "region" {
    description = "The Region of EC2 Instance"
    type = string
    default = "ap-southeast-1"
}

# User data
variable "user_data" {
    description = "The Userdata for EC2 Instance"
    type = string
    default = ""
  
}

