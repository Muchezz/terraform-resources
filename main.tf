#Create a VPC with cidr block

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "terraform-dev"
  }
  
}

#Create a subnet in the VPC

resource "aws_subnet" "main_public_subnet" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
  
  tags = {
    Name = "terraform-dev-public-subnet"
  }
  
}