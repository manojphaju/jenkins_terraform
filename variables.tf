variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "eu-west-2"
}

variable "ami" {
  description = "The AMI ID for the EC2 instance"
  default     = "ami-0a0ff88d0f3f85a14"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "Jenkins-terraform"
}
