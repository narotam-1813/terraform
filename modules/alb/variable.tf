variable "lb_sg_id" {
    description = "mention sg name for lb"
}

variable "sg_vpc_id" {
  description = "mention vpc id for sg"
}

variable "lb_subnet_id" {
  description = "mention public subnet for lb"
}

variable "instance_id" {
    description = "mention instance id for target group"
}

variable "number_of_target_instances" {
  description = "mention how many node you want to create"
}