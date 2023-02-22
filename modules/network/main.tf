// Random id 8 bit suffix
resource "random_id" "suffix_id" {
  byte_length = 8
}

// Random id for public subnets
resource "random_id" "public_subnet_random_id" {
  count       = length(var.public_subnets_cidr)
  byte_length = 2
}

// Random id for private subnets
resource "random_id" "private_subnet_random_id" {
  count       = length(var.private_subnets_cidr)
  byte_length = 2
}

// AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "vpc-${var.environment}-${random_id.suffix_id.hex}"
    Environment = "${var.environment}"
  }
}

// Public subnet
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

// Private subnet
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

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "igw-${var.environment}-${random_id.suffix_id.hex}"
    Environment = "${var.environment}"
  }
}

// Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "public-route-table-${var.environment}"
    Environment = "${var.environment}"
  }
}

// Associate public subnet with route table
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

// Public route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = var.public_route_destination_cidr_block
  gateway_id             = aws_internet_gateway.igw.id
}

// Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "private-route-table-${var.environment}"
    Environment = "${var.environment}"
  }
}

// Associate private subnet with route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

// EC2 instance from custom AMI
resource "aws_instance" "webapp-ec2" {
  ami           = "ami-0e79d6c8684745f26"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name        = "instance-${var.environment}-${random_id.suffix_id.hex}"
    Environment = "${var.environment}"
  }
}

//  EBS volume
resource "aws_ebs_volume" "ebs-volume" {
  availability_zone = var.ec2_availability_zone
  size              = 8
  type              = "gp2"

  tags = {
    Name        = "ebs-volume-${random_id.suffix_id.hex}"
    Environment = "${var.environment}"
  }
}

// Volume attachment
resource "aws_volume_attachment" "ec2_volume_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.ebs-volume.id
  instance_id = aws_instance.webapp-ec2.id
}

// Security group
resource "aws_security_group" "webapp-sg" {
  name        = "application"
  description = "SG for webapp"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 3001
    to_port          = 3001
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "application"
    Environment = "${var.environment}"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.webapp-sg.id
  network_interface_id = aws_instance.webapp-ec2.primary_network_interface_id
}
