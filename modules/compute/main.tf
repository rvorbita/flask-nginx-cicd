resource "aws_key_pair" "deploy" {
  key_name   = "my-day10-key"
  public_key = file("${path.module}/my-day9-key.pub")
}

# 1. The Blueprint (Replaces aws_instance)
resource "aws_launch_template" "flask_app" {
  name_prefix   = "flask-app-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deploy.id

  # Attach the locked-down Compute Security Group
  vpc_security_group_ids = [var.security_group_id]

  # Launch templates require user_data to be base64 encoded!
  user_data = filebase64("${path.root}/docker_install.sh")

  # This ensures instances spawned by the ASG get the right name tag
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Day10-ASG-Flask-Node"
    }
  }
}

# 2. The Manager (Replaces aws_lb_target_group_attachment)
resource "aws_autoscaling_group" "flask_asg" {
  name                = "flask-app-asg"
  vpc_zone_identifier = var.subnet_ids           # Make sure your variables.tf uses plural 'subnet_ids'
  target_group_arns   = [var.target_group_arn]   # Auto-registers new nodes to your ALB automatically
  
  # Tell the ASG to rely on the ALB's health checks
  health_check_type         = "ELB"
  health_check_grace_period = 300 

  min_size         = 1
  max_size         = 3
  desired_capacity = 2 # Starts with 2 instances running

  launch_template {
    id      = aws_launch_template.flask_app.id
    version = "$Latest"
  }
}