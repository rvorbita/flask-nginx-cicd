variable "vpc_cidr" {
    description = "CIDR Block for the VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
    description = "CIDR Block for Public Subnet"
    default = "10.0.0.0/24"
}

variable "public_subnet_cidr_2" {
    description = "CIDR Block for Public Subnet 2"
    default = "10.0.1.0/24"
}

variable "region" {
    description = "Network AWS Region"
    default = "ap-southeast-1"
  
}

variable "allowed_ports" {
    description = "HTTP and SSH Allowed Ports"
    type = list(number)
    default = [22,80]
}