# AMI ID
variable "ami_id" {
    description = "The AMI ID for the EC2 Launch Template"
    type        = string
    default     = "ami-0be9cb9f67c8dabd6"
}

# Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

# 🚀 UPGRADED: Now accepts a list of subnets for the ASG to span across AZs
variable "subnet_ids" {
    description = "A list of Subnet IDs for the Auto Scaling Group"
    type        = list(string)
}

# Security Group ID
variable "security_group_id" {
    description = "The Security Group ID for the EC2 Instances"
    type        = string
}

# Region
variable "region" {
    description = "The AWS Region"
    type        = string
    default     = "ap-southeast-1"
}

# Target Group for the ASG to register instances with
variable "target_group_arn" {
  description = "The ARN of the ALB Target Group to attach the ASG to"
  type        = string
}