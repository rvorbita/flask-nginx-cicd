# Fetch available availability zones in the region
data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "Day10-VPC"
    }
}

resource "aws_subnet" "public_1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidr_1
    map_public_ip_on_launch = true
    availability_zone       = data.aws_availability_zones.available.names[0]
    tags = {
        Name = "Day10-PublicSubnet-1"
    }
}

resource "aws_subnet" "public_2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidr_2
    map_public_ip_on_launch = true
    availability_zone       = data.aws_availability_zones.available.names[1]
    tags = {
        Name = "Day10-PublicSubnet-2"
    }
}

# 1. New Security Group for the Load Balancer (Public Facing)
resource "aws_security_group" "alb_sg" {
    name        = "Day10-ALB-SG"
    description = "Allow HTTP inbound traffic from anywhere to the ALB"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    tags = {
        Name = "Day10-ALB-SG"
    }
}

# 2. Updated Security Group for Compute (Private to ALB + Dynamic Ports)
resource "aws_security_group" "compute_sg" {
    name        = "Day10-Compute-SG"
    description = "Allow HTTP from ALB and dynamic allowed ports"
    vpc_id      = aws_vpc.main.id
    
    # Allow HTTP ONLY from the ALB Security Group
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.alb_sg.id] 
    }

    # Your untouched dynamic ingress for variable ports (e.g., SSH)
    dynamic "ingress" {
        for_each = var.allowed_ports
        content {
          from_port   = ingress.value
          to_port     = ingress.value
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
    }

    # Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    tags = {
      Name = "Day10-Compute-SG"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "igw_main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "Day10-Internet-Gateway"
    }
}

# Route Table
resource "aws_route_table" "public_rtc" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "Day10-Public-Route-Table"
    }
}

# Route Table to Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rtc.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_main.id
}

# Associate Route Table with Public Subnet 1
resource "aws_route_table_association" "public_1_assoc" {
    subnet_id      = aws_subnet.public_1.id
    route_table_id = aws_route_table.public_rtc.id
}

# Associate Route Table with Public Subnet 2
resource "aws_route_table_association" "public_2_assoc" {
    subnet_id      = aws_subnet.public_2.id
    route_table_id = aws_route_table.public_rtc.id
}