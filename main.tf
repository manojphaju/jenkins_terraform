
# provider "aws" {
#   region = var.region
# }

# resource "aws_instance" "foo" {
#   ami           = var.ami
#   instance_type = var.instance_type

#   tags = {
#     Name = var.instance_name
#   }
# }



# multiple instances
provider "aws" {
  region = var.region
}

resource "aws_instance" "foo" {
  for_each      = var.instances
  ami           = var.ami
  instance_type = each.value

  tags = {
    Name = each.key
  }
}
