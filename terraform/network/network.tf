provider "aws" {
    version = "2.67"
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = var.vpc_name
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "pub_subnet_a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pub_subnet_a.cidr
    availability_zone = var.pub_subnet_a.az

    tags = {
        Name = var.pub_subnet_a.name
    }
}

resource "aws_subnet" "pub_subnet_b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pub_subnet_b.cidr
    availability_zone = var.pub_subnet_b.az

    tags = {
        Name = var.pub_subnet_b.name
    }
}

resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = var.pub_rt_name
    }
}

resource "aws_route_table_association" "rta_pub_a" {
    subnet_id = aws_subnet.pub_subnet_a.id
    route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "rta_pub_b" {
    subnet_id = aws_subnet.pub_subnet_b.id
    route_table_id = aws_route_table.pub_rt.id
}

resource "aws_eip" "nat" {
    vpc = true
    tags = {
        Name = "nat-gateway-eip"
    }
}

resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.pub_subnet_a.id
    depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "priv_subnet_a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.priv_subnet_a.cidr
    availability_zone = var.priv_subnet_a.az

    tags = {
        Name = var.priv_subnet_a.name
    }
}

resource "aws_subnet" "priv_subnet_b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.priv_subnet_b.cidr
    availability_zone = var.priv_subnet_b.az

    tags = {
        Name = var.priv_subnet_b.name
    }
}

resource "aws_route_table" "priv_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.ngw.id
    }

    tags = {
        Name = var.priv_rt_name
    }
}

resource "aws_route_table_association" "rta_priv_a" {
    subnet_id = aws_subnet.priv_subnet_a.id
    route_table_id = aws_route_table.priv_rt.id
}

resource "aws_route_table_association" "rta_priv_b" {
    subnet_id = aws_subnet.priv_subnet_b.id
    route_table_id = aws_route_table.priv_rt.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.eu-central-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.priv_rt.id,
    aws_route_table.pub_rt.id,
  ]
}
