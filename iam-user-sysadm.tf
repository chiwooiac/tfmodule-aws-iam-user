locals {
  sysAdm_group_name       = format("%s%s", local.project, replace(title( "SysAdmin-Group"), "-", "" ))
  sysAdm_group_membership = format("%s%s", local.project, replace(title( "SysAdmin-Group-member"), "-", "" ))
  users_sysAdm            = [for u in var.users : u.name if u.create == 1 && u.sysadm == 1]
}

resource "aws_iam_group" "sysAdm" {
  name = local.sysAdm_group_name
}

resource "aws_iam_group_membership" "sysAdm" {
  name  = local.sysAdm_group_membership
  group = aws_iam_group.sysAdm.name
  users = local.users_sysAdm

  depends_on = [aws_iam_user.this]
}

# policies for admin user group

resource "aws_iam_group_policy_attachment" "policies_sysadm" {
  count      = length(var.policies_sysadm)
  group      = aws_iam_group.sysAdm.name
  policy_arn = element(var.policies_sysadm, count.index )
}
