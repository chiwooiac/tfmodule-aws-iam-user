locals {
  dba_group_name       = format("%s%s", local.project, replace(title( "DBA-Group"), "-", "" ))
  dba_group_membership = format("%s%s", local.project, replace(title( "DBA-Group-member"), "-", "" ))
  users_dba            = [for u in var.users : u.name if u.create == 1 && u.dba == 1]
}

resource "aws_iam_group" "dba" {
  name = local.dba_group_name
}

resource "aws_iam_group_membership" "dba" {
  name  = local.dba_group_membership
  group = aws_iam_group.dba.name
  users = local.users_dba

  depends_on = [aws_iam_user.this]
}

# policies for dba user group
resource "aws_iam_group_policy_attachment" "policies_dba" {
  count      = length(var.policies_dba)
  group      = aws_iam_group.dba.name
  policy_arn = element(var.policies_dba, count.index )
}
