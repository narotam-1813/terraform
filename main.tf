module "vpc" {
    source = "./modules/vpc"
    vpc_name = "narotam"
  
}

module "ec2" {
  source = "./modules/ec2"
  instance_name = "narotam-project-node"
  instance_ami = "ami-051f8a213df8bc089"
  instance_type = "t2.micro"
  instance_sg_name = "narotam-instance-sg"
  sg_vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  number_of_instances = 1
}