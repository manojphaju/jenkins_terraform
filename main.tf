provider "aws" {
    region = "eu-west-2"  
}

resource "aws_instance" "foo" {
  ami           = "ami-0a0ff88d0f3f85a14" # us-west-2
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}
