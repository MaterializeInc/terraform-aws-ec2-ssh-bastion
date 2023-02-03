data "aws_availability_zones" "available" {}

data "http" "user_public_ip" {
  url = "https://ifconfig.me/ip"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Get the VPC details using aws_vpc
data "aws_vpc" "mz_vpc" {
  id = var.vpc_id
}
