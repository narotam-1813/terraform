output "instance_id" {
  value = [ aws_instance.ec2[*].id ]
}

output "instance_sg_id" {
  value = aws_security_group.instance_sg.id
}

output "instance_subnet_id" {
  value = [aws_instance.ec2[*].subnet_id]
}