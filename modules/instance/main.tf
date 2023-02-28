data "aws_ami" "custom_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["webapp-ami-*"]
  }
}

// Random id 8 bit suffix
resource "random_id" "suffix_id" {
  byte_length = 8
}

// EC2 instance from custom AMI
resource "aws_instance" "webapp-ec2" {
  ami                     = var.ec2_source_ami == null ? data.aws_ami.custom_ami.id : var.ec2_source_ami
  instance_type           = var.ec2_instance_type
  subnet_id               = var.ec2_target_subnet_id
  disable_api_termination = false

  root_block_device {
    volume_size           = var.ebs_size
    volume_type           = var.ebs_type
    delete_on_termination = var.ebs_delete_on_termination
  }

  tags = {
    Name        = "instance-${var.instance_environment}-${random_id.suffix_id.hex}"
    Environment = "${var.instance_environment}"
  }
}

// Security group
resource "aws_security_group" "webapp-sg" {
  name        = var.application_sg_name
  description = "SG for webapp"
  vpc_id      = var.ec2_sg_target_vpc_id

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
    Name        = "application"
    Environment = "${var.instance_environment}"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.webapp-sg.id
  network_interface_id = aws_instance.webapp-ec2.primary_network_interface_id
}
