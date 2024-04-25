output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = [aws_subnet.public_subnets[*].id]
}

output "private_subnet_id" {
  value = [aws_subnet.private_subnets[*].id]
}

output "eip" {
  value = aws_eip.nat_eip.id
}