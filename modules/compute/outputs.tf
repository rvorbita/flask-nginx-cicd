output "instance_public_ip" {
    value = aws_instance.compute.public_ip
}