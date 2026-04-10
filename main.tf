module "network" {
  source = "./modules/network"
  region = var.region
}

module "compute" {
  source = "./modules/compute"
  region = var.region

  # Connect the EC2 instance to the Target Group created by the ALB module
  target_group_arn = module.alb.target_group_arn

  # Grab the FIRST subnet from the new list of public subnets
  subnet_id = module.network.public_subnet_ids[0]

  # Use the newly renamed compute security group
  security_group_id = module.network.compute_security_group_id
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.network.vpc_id

  # Pass the entire list of subnets directly from the network output
  public_subnet_ids = module.network.public_subnet_ids

  # Attach the ALB-specific security group
  alb_sg_id = module.network.alb_security_group_id
}

# Keep the EC2 public IP if you still need it for SSH troubleshooting
output "instance_public_ip" {
  value = module.compute.instance_public_ip
}

# NEW: Output the Load Balancer DNS Name so you can access your web app!
output "load_balancer_dns" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}