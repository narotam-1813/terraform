module "vpc" {
    source = "./modules/vpc"
    vpc_name = "narotam"
  
}

resource "aws_security_group" "lb_sg" {
  name = "lb-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol   = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

module "ec2" {
  source = "./modules/ec2"
  instance_name = "narotam-project-node"
  instance_ami = "ami-051f8a213df8bc089"
  instance_type = "t2.micro"
  instance_sg_name = "narotam-instance-sg"
  sg_vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.private_subnet_id[0]
  number_of_instances = var.number_of_instances
  lb_sg_id = aws_security_group.lb_sg.id
}

# locals {
#   create_alb = module.ec2.instance_subnet_id == module.vpc.private_subnet_id[0] ? true : false
# }

module "alb" {
  source = "./modules/alb"
  # count = local.create_alb ? 1 : 0
  count = var.number_of_instances
  number_of_target_instances = var.number_of_instances
  instance_id = module.ec2.instance_id[count.index]
  sg_vpc_id = module.vpc.vpc_id
  lb_subnet_id = module.vpc.public_subnet_id
  lb_sg_id = aws_security_group.lb_sg.id
}

# resource "aws_security_group_rule" "lb_ingress_to_instance" {
#   # count = local.create_alb ? 1 : 0
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   security_group_id = module.ec2.instance_sg_id
#   source_security_group_id = module.alb[0].alb_sgs_id
# }