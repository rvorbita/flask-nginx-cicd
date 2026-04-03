resource "aws_key_pair" "deploy" {
  key_name = "my-day9-key"
  public_key = file("${path.module}/my-day9-key.pub")
}

resource "aws_instance" "compute" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    key_name = aws_key_pair.deploy.id
    vpc_security_group_ids = [var.security_group_id]

    user_data = file("${path.root}/docker_install.sh")
  
    tags = {
        Name = "Day09 Project Ec2 Instance"
    }
    
}