provider "aws" {}

# EC2-Jump-Host

resource "aws_instance" "instance-jump-host" {
  ami           = var.ami_ubuntu_arm
  instance_type = var.ec2_type_t4g_nano

  vpc_security_group_ids = ["${aws_security_group.jump-host-terraform.id}"]
  subnet_id              = aws_subnet.subnet-public-1a.id

  tags = {
    "Name" = "Jump-host-terraform"
  }
}

# EC2-Nginx-Host

resource "aws_instance" "instance-nginx-host" {
  ami           = var.ami_nginx
  instance_type = var.ec2_type_t2_micro

  vpc_security_group_ids = ["${aws_security_group.nginx-host-terraform.id}"]
  subnet_id              = aws_subnet.subnet-private-1a.id

  tags = {
    "Name" = "Nginx-host-terraform"
  }
}
