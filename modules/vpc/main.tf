resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      "Name" = var.vpc_name
    }
}

resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnets_cidr)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnets_cidr[count.index]
    availability_zone = data.aws_availability_zones.available_zones.names[count.index]
    tags = {
      "Name" = "Public_subnet_${count.index}" 
    }
}

resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnets_cidr[count.index]
    availability_zone = data.aws_availability_zones.available_zones.names[count.index]
    tags = {
      "Name" = "Private_subnet_${count.index}" 
    }
}

resource "aws_internet_gateway" "vpc_ig" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      "Name" = "${var.vpc_name}-vpc-ig"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
    depends_on = [ aws_internet_gateway.vpc_ig ]
}

resource "aws_nat_gateway" "vpc_nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = element(aws_subnet.public_subnets.*.id, 0)
    depends_on = [ aws_internet_gateway.vpc_ig ]
    tags = {
      "Name" = "${var.vpc_name}-vpc-nat"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      "Name" = "public-subnet-rt"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      "Name" = "private-subnet-rt"
    }
}

resource "aws_route" "public_ig_route" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ig.id
}

resource "aws_route" "private_nat_route" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc_nat.id
}

resource "aws_route_table_association" "public_rt_association" {
    count = length(var.public_subnets_cidr)
    subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_rt_association" {
    count = length(var.private_subnets_cidr)
    subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
    route_table_id = aws_route_table.private.id
}
