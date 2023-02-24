locals {
  admin_group_name       = format("%s%s", local.project, replace(title( "Admin-Group"), "-", "" ))
  admin_group_membership = format("%s%s", local.project, replace(title( "Admin-Group-member"), "-", "" ))
  users_admin            = [for u in var.users : u.name if u.create == 1 && u.admin == 1]
}

resource "aws_iam_group" "admin" {
  name = local.admin_group_name
}

resource "aws_iam_group_membership" "admin" {
  name  = local.admin_group_membership
  group = aws_iam_group.admin.name
  users = local.users_admin

  depends_on = [aws_iam_user.this]
}

# policies for admin user group

resource "aws_iam_group_policy_attachment" "policy_admin" {
  count      = length(var.policies_admin)
  group      = aws_iam_group.admin.name
  policy_arn = element(var.policies_admin, count.index )
}
