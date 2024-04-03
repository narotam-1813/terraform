variable "vpc_cidr" {
    default = "10.0.0.0/16"
    description = "mention cidr for vpc"
}
variable "public_subnets_cidr" {
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}

data "aws_availability_zones" "available_zones" {
    state = "available"
}

variable "vpc_name" {
  description = "mention name of the vpc"
}