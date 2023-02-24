locals {
  viewer_group_name       = format("%s%s", local.project, replace(title( "viewer-Group"), "-", "" ))
  viewer_group_membership = format("%s%s", local.project, replace(title( "viewer-Group-member"), "-", "" ))
  users_viewer            = [for u in var.users : u.name if u.create == 1 && u.viewer == 1]
}

resource "aws_iam_group" "viewer" {
  name = local.viewer_group_name
}

resource "aws_iam_group_membership" "viewer" {
  name  = local.viewer_group_membership
  group = aws_iam_group.viewer.name
  users = local.users_viewer

  depends_on = [aws_iam_user.this]
}

# policies for viewer user group

resource "aws_iam_group_policy_attachment" "policies_viewer" {
  count      = length(var.policies_viewer)
  group      = aws_iam_group.viewer.name
  policy_arn = element(var.policies_viewer, count.index )
}
