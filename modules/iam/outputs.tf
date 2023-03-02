output "s3_iam_instance_profile" {
  value = aws_iam_instance_profile.ec2_s3_profile.id
}
