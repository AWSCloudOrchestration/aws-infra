## ------------------------------------------
## IAM MODULE
## ------------------------------------------

## S3 IAM policy
resource "aws_iam_policy" "s3_iam_policy" {
  name        = var.s3_iam_policy_name
  path        = "/"
  description = "Policy to allow EC2 instances to access S3 buckets"

  policy = jsonencode({
    Version = var.iam_policy_version
    Statement = [
      {
        Action = var.s3_iam_policy_actions
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

## IAM role
resource "aws_iam_role" "ec2_iam_role" {
  name = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = var.iam_policy_version
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Environment = var.iam_environment
  }
}

## IAM role-policy attachment for s3
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = aws_iam_policy.s3_iam_policy.arn
  role       = aws_iam_role.ec2_iam_role.name
}

## IAM role policy attachement for cloudwatch
resource "aws_iam_role_policy_attachment" "cw_policy_attachment" {
  policy_arn = var.cw_agent_server_policy_arn
  role       = aws_iam_role.ec2_iam_role.name
}

## IAM instance profile
resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = var.iam_role_name
  role = aws_iam_role.ec2_iam_role.name
}
