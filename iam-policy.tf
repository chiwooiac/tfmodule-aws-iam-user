locals {
  mfa_policy         = format("%sMFAForcePolicy", local.project)
  deny_ipaddr_policy = format("%sDenyIPAddressPolicy", local.project)
  src_ipaddr      = trimspace(jsonencode(var.deny_ipaddr))
}

data "template_file" "DenyIPAddressPolicy" {
  template = file("${path.module}/policies/DenyIPAddressPolicy.json")
  vars     = {
    SOURCE_IPADDR = local.src_ipaddr
  }
}

data "template_file" "MFAForcePolicy" {
  template = file("${path.module}/policies/MFAForcePolicy.json")
  vars     = {}
}

resource "aws_iam_policy" "DenyIPAddressPolicy" {
  name        = local.deny_ipaddr_policy
  description = "Deny access not defined by source IP Address."
  path        = var.policy_path
  policy      = data.template_file.DenyIPAddressPolicy.rendered
  tags        = merge(local.tags, {
    Name = local.deny_ipaddr_policy
  })
}

resource "aws_iam_policy" "MFAForcePolicy" {
  name        = local.mfa_policy
  description = "Deny access for non-MFA authentication."
  path        = var.policy_path
  policy      = data.template_file.MFAForcePolicy.rendered
  tags        = merge(local.tags, {
    Name = local.mfa_policy
  })
}
