variable "vpc_id" {
    description = "VPC ID for ALB"
    type = string
    default = ""

}

variable "public_subnets" {
    description = "Public Sunet for ALB"
    type = string
    default = ""
}

variable "alb_sg_id" {
    description = "Security Group ID for ALB"
    type = string
    default = ""
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs in different Availability Zones"
  type        = list(string)
}