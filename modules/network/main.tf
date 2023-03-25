#############################################
## NETWORK MODULE
#############################################

## Random id 8 bit suffix
resource "random_id" "suffix_id" {
  byte_length = 8
}

## Random id for public subnets
resource "random_id" "public_subnet_random_id" {
  count       = length(var.public_subnets_cidr)
  byte_length = 2
}

## Random id for private subnets
resource "random_id" "private_subnet_random_id" {
  count       = length(var.private_subnets_cidr)
  byte_length = 2
}

## AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "vpc-${var.environment}-${random_id.suffix_id.hex}"
    Environment = "${var.environment}"
  }
}

## Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-${var.environment}-${element(var.availability_zones, count.index)}-${random_id.public_subnet_random_id.*.hex[count.index]}"
    Environment = "${var.environment}"
  }
}

## Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "private-subnet-${var.environment}-${element(var.availability_zones, count.index)}-${random_id.private_subnet_random_id.*.hex[count.index]}"
    Environment = "${var.environment}"
  }
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "igw-${var.environment}-${random_id.suffix_id.hex}"
    Environment = "${var.environment}"
  }
}

## Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "public-route-table-${var.environment}"
    Environment = "${var.environment}"
  }
}

## Associate public subnet with route table
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

## Public route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = var.public_route_destination_cidr_block
  gateway_id             = aws_internet_gateway.igw.id
}

## Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "private-route-table-${var.environment}"
    Environment = "${var.environment}"
  }
}

## Associate private subnet with route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
