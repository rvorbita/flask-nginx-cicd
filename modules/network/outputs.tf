# output "vpc_id" {
#     value = aws_vpc.main.id
# }

# output "public_subnet_id" {
#     value = aws_subnet.public.id
# }

# output "security_group_id" {
#     value = aws_security_group.sg-allow-http-and-ssh.id
# }

# output "internet_gateway_id" {
#     value = aws_internet_gateway.igw_main.id
# }

# output "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
# }

# output "alb_security_group_id" {
#   # Assuming you created a specific SG for the ALB, or rename this to match your existing SG
#   value = aws_security_group.sg-allow-http-and-ssh.id 
# }

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "alb_security_group_id" {
  description = "The ID of the ALB Security Group"
  value       = aws_security_group.alb_sg.id
}

output "compute_security_group_id" {
  description = "The ID of the Compute Security Group"
  value       = aws_security_group.compute_sg.id
}