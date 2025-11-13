output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.foo.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.foo.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.foo.private_ip
}
