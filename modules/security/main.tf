resource "aws_security_group" "webapp-sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.sg_target_vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = var.ingress_security_groups
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_rules
    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      security_groups = var.egress_security_groups
    }
  }

  tags = {
    Name        = "${var.sg_name}"
    Environment = "${var.sg_environment}"
  }
}
