output "caller_account_id" {
  value = data.aws_caller_identity.current_caller.account_id
}

output "called_account_arn" {
    value = data.aws_caller_identity.current_caller.arn
}