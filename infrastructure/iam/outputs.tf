output "execution_role" {
  value   = aws_iam_role.execution_role.name
}

output "execution_role_arn" {
  value   = aws_iam_role.execution_role.arn
}