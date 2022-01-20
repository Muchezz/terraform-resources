#Create a VPC with cidr block
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "terraform-dev"
  }

}

#Create a subnet in the VPC
resource "aws_subnet" "main_public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "terraform-dev-public-subnet"
  }

}

#Create an Internet Gateway
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "terraform-dev-igw"
  }
}

# Create a route table
resource "aws_route_table" "dev_public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "terraform-dev-public-route-table"
  }
}

#create a route to the internet gateway
resource "aws_route" "dev_public_route" {
  route_table_id         = aws_route_table.dev_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_igw.id
}


#Route the subnet to the route table
resource "aws_route_table_association" "dev_public_route_table_association" {
  subnet_id      = aws_subnet.main_public_subnet.id
  route_table_id = aws_route_table.dev_public_route_table.id
}

#Create a security group
resource "aws_security_group" "dev_sg" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "terraform-dev-sg"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create an EC2
resource "aws_instance" "dev_node" {
  ami                         = data.aws_ami.server_ami.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.dev_sg.id]
  subnet_id                   = aws_subnet.main_public_subnet.id
  user_data = file("userdata.tpl")
  associate_public_ip_address = true
  tags = {
    Name = "terraform-dev-node"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}