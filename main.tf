provider "aws" {
    region = "ap-southeast-2"  
}

resource "aws_instance" "foo" {
  ami           = "ami-0b8d527345fdace59" # us-west-2
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}
