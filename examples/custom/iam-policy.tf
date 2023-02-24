data "template_file" "DenyDataPipeline" {
  template = file("./policies/DenyDataPipelinePolicy.json")
  vars     = {}
}

data "template_file" "DenyDeveloperPolicy" {
  template = file("./policies/DenyDeveloperPolicy.json")
  vars     = {}
}

data "template_file" "DenyEC2StopAndTerminationMFAPolicy" {
  template = file("./policies/DenyEC2StopAndTerminationMFAPolicy.json")
  vars     = {}
}

data "template_file" "DenyGeneralAccessPolicy" {
  template = file("./policies/DenyGeneralAccessPolicy.json")
  vars     = {}
}

data "template_file" "DenyRDSLargeCreationPolicy" {
  template = file("./policies/DenyRDSLargeCreationPolicy.json")
  vars     = {}
}

locals {
  deny_datapipe_policy         = format("%sDenyDataPipelinePolicy", local.project)
  deny_developer_policy        = format("%sDenyDeveloperPolicy", local.project)
  deny_ec2terminate_mfa_policy = format("%sDenyEC2StopAndTerminationMFAPolicy", local.project)
  deny_general_access_policy   = format("%sDenyGeneralAccessPolicy", local.project)
  deny_rds_large_create_policy = format("%sDenyRDSLargeCreationPolicy", local.project)
}

resource "aws_iam_policy" "DenyDataPipelinePolicy" {
  name        = local.deny_datapipe_policy
  description = "Deny access to users who have not created this data pipeline."
  path        = var.policy_path
  policy      = data.template_file.DenyDataPipeline.rendered
  tags        = merge(local.tags, {
    Name = local.deny_datapipe_policy
  })
}

resource "aws_iam_policy" "DenyDeveloperPolicy" {
  name        = local.deny_developer_policy
  description = "Does not allow developers to have policies, such as deleting resources that cause service failures."
  path        = var.policy_path
  policy      = data.template_file.DenyDeveloperPolicy.rendered
  tags        = merge(local.tags, {
    Name = local.deny_developer_policy
  })
}

resource "aws_iam_policy" "DenyEC2StopAndTerminationMFAPolicy" {
  name        = local.deny_ec2terminate_mfa_policy
  description = "Denies stopping and terminating EC2 instances for authentication without MFA authentication."
  path        = var.policy_path
  policy      = data.template_file.DenyEC2StopAndTerminationMFAPolicy.rendered
  tags        = merge(local.tags, {
    Name = local.deny_ec2terminate_mfa_policy
  })
}

resource "aws_iam_policy" "DenyGeneralAccessPolicy" {
  name        = local.deny_general_access_policy
  description = "Deny user actions (requests) that cause service failure."
  path        = var.policy_path
  policy      = data.template_file.DenyGeneralAccessPolicy.rendered
  tags        = merge(local.tags, {
    Name = local.deny_general_access_policy
  })
}

resource "aws_iam_policy" "DenyRDSLargeCreationPolicy" {
  name        = local.deny_rds_large_create_policy
  description = "Deny RDS instance creation with a very large instance type."
  path        = var.policy_path
  policy      = data.template_file.DenyRDSLargeCreationPolicy.rendered
  tags        = merge(local.tags, {
    Name = local.deny_rds_large_create_policy
  })
}
