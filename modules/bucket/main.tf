#############################################
## BUCKET MODULE
#############################################

## Random id 
resource "random_id" "bucket_name_random_id" {
  byte_length = 2
}

## S3 Bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket        = "webapp-${var.s3_environment}-bucket-${random_id.bucket_name_random_id.hex}"
  force_destroy = var.s3_force_destroy
  tags = {
    Name        = "webapp-${var.s3_environment}-bucket-${random_id.bucket_name_random_id.hex}"
    Environment = "${var.s3_environment}"
  }
}

## Versioning
resource "aws_s3_bucket_versioning" "s3_versioning_configuration" {
  bucket = aws_s3_bucket.private_bucket.id
  versioning_configuration {
    status = var.s3_versioning_configuration
  }
}

## ACL
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.private_bucket.id
  acl    = var.s3_bucket_acl
}

## Public access block
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls       = var.s3_block_public_acls
  block_public_policy     = var.s3_ignore_public_acls
  ignore_public_acls      = var.s3_ignore_public_acls
  restrict_public_buckets = var.s3_restrict_public_buckets
}

## Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption_configuration" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.s3_sse_algorithm
    }
  }
}

## Lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_configuration" {
  bucket = aws_s3_bucket.private_bucket.id
  rule {
    id     = "transition-to-standard-ia"
    status = "Enabled"

    transition {
      days          = var.transition_to_IA_days
      storage_class = "STANDARD_IA"
    }
  }
}

