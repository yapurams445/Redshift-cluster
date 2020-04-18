// provider "aws" {
//   region = var.vpc_region
// }

# Define a vpc
resource "aws_vpc" "datascience_gb_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

#Internet gateway for the public subnet

resource "aws_internet_gateway" "datascience_gb_igw" {
  vpc_id = aws_vpc.datascience_gb_vpc.id
  tags = {
    Name = "${var.vpc_name}_igw"
  }
}

# Public subnet

resource "aws_subnet" "public" {
  count             = length(var.vpc_public_subnet_cidr)
  vpc_id            = aws_vpc.datascience_gb_vpc.id
  cidr_block        = element(var.vpc_public_subnet_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "Public-Subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.vpc_public_subnet_cidr)
  vpc_id            = aws_vpc.datascience_gb_vpc.id
  cidr_block        = element(var.vpc_private_subnet_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "Private-Subnet-${count.index + 1}"
  }
}

# Routing table for public subnet
resource "aws_route_table" "vpc_public_sn_rt" {
  vpc_id = aws_vpc.datascience_gb_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.datascience_gb_igw.id
  }
  tags = {
    Name = "vpc_public_sn_rt"
  }
}

resource "aws_route_table_association" "a" {
  count          = length(var.vpc_public_subnet_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.vpc_public_sn_rt.id
}

