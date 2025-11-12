provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "foo" {
  ami           = "ami-0d5d9d301c853a04a"  # Amazon Linux 2 in Sydney
  instance_type = "t2.micro"

  tags = {
    Name = "TF-Instance"
  }
}
