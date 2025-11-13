provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "foo" {
  ami           = "ami-0a0ff88d0f3f85a14"  
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins-terraform"
  }
}
