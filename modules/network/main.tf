data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "${var.environment}-vpc"
    Environment = "${var.environment}"
  }
}

// Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.public_subnets_cidr)}"
  cidr_block              = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
#   map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = "${var.environment}"
  }
}

// Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.environment}"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name        = "${var.environment}-igw"
    Environment = "${var.environment}"
  }
}

// Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

// Public route
resource "aws_route" "public_route" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

// Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}