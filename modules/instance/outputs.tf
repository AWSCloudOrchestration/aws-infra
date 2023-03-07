output "ec2_public_ip" {
  value = aws_instance.webapp-ec2.public_ip
}