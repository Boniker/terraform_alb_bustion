output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id_public_1a" {
  value = aws_subnet.subnet-public-1a.id
}

output "subnet_id_private_1a" {
  value = aws_subnet.subnet-private-1a.id
}