variable "instance_name" {
  description = "mention instance name"
}

variable "instance_ami" {
  description = "mention ami id"
}

variable "instance_type" {
  description = "mention instance type"
}

variable "subnet_id" {
  type = list(string)
  description = "mention subnet id for instance"
}

data "aws_key_pair" "instance_key" {
  key_name = "narotam_test"
}

variable "instance_sg_name" {
  description = "mention instance security name"
}

variable "sg_vpc_id" {
  description = "mention vpc id for sg"
}

variable "number_of_instances" {
  description = "mention how many node you want to create"
}

variable "lb_sg_id" {
  description = "mention lb security group id"
}