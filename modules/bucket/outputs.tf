output "s3_bucket_name" {
    description = "S3 bucket name"
  value = split(":::", aws_s3_bucket.private_bucket.arn)[1]
}

output "s3_aws_region" {
    description = "S3 bucket region"
    value = aws_s3_bucket.private_bucket.region
}