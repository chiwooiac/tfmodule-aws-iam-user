locals {
  developer_group_name       = format("%s%s", local.project, replace(title( "developer-group"), "-", "" ))
  developer_group_membership = format("%s%s", local.project, replace(title( "developer-group-member"), "-", "" ))
  users_developer            = [for u in var.users : u.name if u.create == 1 && u.developer == 1]
}

resource "aws_iam_group" "developer" {
  name = local.developer_group_name
}

resource "aws_iam_group_membership" "developer" {
  name  = local.developer_group_membership
  group = aws_iam_group.developer.name
  users = local.users_developer
}

# policies for developer user group

resource "aws_iam_group_policy_attachment" "policies_developer" {
  count      = length(var.policies_developer)
  group      = aws_iam_group.developer.name
  policy_arn = element(var.policies_developer, count.index )
}
