output "MFAForcePolicy_arn" {
  value = aws_iam_policy.MFAForcePolicy.arn
}

output "DenyIPAddressPolicy_arn" {
  value = aws_iam_policy.DenyIPAddressPolicy.arn
}
