# output "instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.foo.id
# }

# output "instance_public_ip" {
#   description = "Public IP of the EC2 instance"
#   value       = aws_instance.foo.public_ip
# }

# output "instance_private_ip" {
#   description = "Private IP of the EC2 instance"
#   value       = aws_instance.foo.private_ip
# }


# for multples

output "instance_ids" {
  description = "IDs of all EC2 instances"
  value       = { for k, v in aws_instance.foo : k => v.id }
}

output "instance_public_ips" {
  description = "Public IPs of all EC2 instances"
  value       = { for k, v in aws_instance.foo : k => v.public_ip }
}

output "instance_private_ips" {
  description = "Private IPs of all EC2 instances"
  value       = { for k, v in aws_instance.foo : k => v.private_ip }
}
