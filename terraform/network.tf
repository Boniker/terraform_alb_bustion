# Security group for Jump host

resource "aws_security_group" "jump-host-terraform" {
  name   = "Security group jump host terraform"
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = [var.all_traffic]
    description = "Inbound rules"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = [var.all_traffic]
    description = "Outbound rules"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    "Name" = "jump-host-terraform"
  }
}

# Security group for Nginx

resource "aws_security_group" "nginx-host-terraform" {
  name   = "Security group nginx host terraform"
  vpc_id = aws_vpc.main.id

  ingress {
    security_groups = ["${aws_security_group.jump-host-terraform.id}"]
    description     = "Inbound rules"
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
  }

  ingress {
    security_groups = ["${aws_default_security_group.sg-default.id}"]
    description     = "Inbound rules"
    from_port       = 8000
    protocol        = "tcp"
    to_port         = 9000
  }

  egress {
    cidr_blocks = [var.all_traffic]
    description = "Outbound rules"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    "Name" = "nginx-host-terraform"
  }
}

# Security group default

resource "aws_default_security_group" "sg-default" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Inbound rules"
    from_port   = 0
    protocol    = "-1"
    self        = true
    to_port     = 0
  }

  ingress {
    cidr_blocks = [var.all_traffic]
    description = "Inbound rules"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    cidr_blocks = [var.all_traffic]
    description = "Outbound rules"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    "Name" = "sg-default-terraform"
  }
}

# VPC-HW6-terraform

resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    "Name" = "vpc-terraform"
  }
}


# Subnets-HW6-terraform

resource "aws_subnet" "subnet-public-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1a"

  tags = {
    "Name" = "sn-public-1a-hw6-terraform"
  }
}

resource "aws_subnet" "subnet-private-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1a"

  tags = {
    "Name" = "sn-private-1a-terraform"
  }
}

resource "aws_subnet" "subnet-public-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1b"

  tags = {
    "Name" = "sn-public-1b-terraform"
  }
}

resource "aws_subnet" "subnet-private-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1b"

  tags = {
    "Name" = "sn-private-1b-terraform"
  }
}

# Internet gateways

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "igw-terraform"
  }
}

# Route Tables

resource "aws_main_route_table_association" "rt-main-public" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.all_traffic
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "rt-public-terraform"
  }
}

resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "rt-private-terraform"
  }
}

## Subnet association public

resource "aws_route_table_association" "subnet-public-1a-assoc" {
  subnet_id      = aws_subnet.subnet-public-1a.id
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table_association" "subnet-public-1b-assoc" {
  subnet_id      = aws_subnet.subnet-public-1b.id
  route_table_id = aws_route_table.rt-public.id
}

## Subnet association private

resource "aws_route_table_association" "subnet-private-1a-assoc" {
  subnet_id      = aws_subnet.subnet-private-1a.id
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_route_table_association" "subnet-private-1b-assoc" {
  subnet_id      = aws_subnet.subnet-private-1b.id
  route_table_id = aws_route_table.rt-private.id
}