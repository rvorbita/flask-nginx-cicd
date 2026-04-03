resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "Day09-VPC"
    }
  
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = true
    tags = {
        Name = "Day09-PublicSubnet"
    }
  
}

resource "aws_security_group" "sg-allow-http-and-ssh" {
    name = "Day09-ComputeSG"
    description = "Security Group Allow HTTP and SSH"
    vpc_id = aws_vpc.main.id
    
    #allow SSH and HTTP inblound traffic.
    dynamic "ingress" {
        for_each = var.allowed_ports
        content {
          from_port = ingress.value
          to_port = ingress.value
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
    }

      # Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] # allow to anywhere
    }

    tags = {
      Name = "Day07-sg-allow-ss-http"
    }
}


# Internet Gateway
resource "aws_internet_gateway" "igw_main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "Day 7 Internet Gateway"
    }
}

# Route Table
resource "aws_route_table" "public_rtc" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "Day 7 Public Route Table"
    }
}

# Route Table to Internet Gateway.
resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public_rtc.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_main.id

}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_rtc_assoc" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public_rtc.id

}