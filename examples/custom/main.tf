module "ctx" {
  source  = "git::https://github.com/chiwooiac/tfmodule-context.git"
  context = {
    aws_profile = "prd"
    region      = "ap-northeast-2"
    project     = "apple"
    environment = "Production"
    owner       = "manager@symplesims.io"
    team        = "DevOps"
    cost_center = "20220220"
    domain      = "devops.symplesims.io"
    pri_domain  = "symplesims.backend.intra"
  }
}

locals {
  project     = module.ctx.project
  tags        = module.ctx.tags
  name_prefix = module.ctx.name_prefix
}

module "users" {
  source  = "../../"
  context = module.ctx.context
  //@formatter:off
  users = [
    { name = "admin@symplesims.io",    create=1, admin=1, developer=0, dba=0, sysadm=0, viewer=0 },
    { name = "manager@symplesims.io",  create=1, admin=0, developer=0, dba=0, sysadm=1, viewer=0 },
    { name = "devlamp@symplesims.io",  create=1, admin=0, developer=1, dba=0, sysadm=0, viewer=0 },
    { name = "devapple@symplesims.io", create=1, admin=0, developer=1, dba=0, sysadm=0, viewer=0 },
    { name = "scott@symplesims.io",    create=1, admin=0, developer=0, dba=1, sysadm=0, viewer=0 },
    { name = "tiger@symplesims.io",    create=1, admin=0, developer=0, dba=1, sysadm=0, viewer=0 },
    { name = "viewer@symplesims.io",   create=1, admin=0, developer=0, dba=0, sysadm=0, viewer=1 },
    { name = "reporter@symplesims.io", create=1, admin=0, developer=0, dba=0, sysadm=0, viewer=1 },
    { name = "cfalron@symplesims.io",  create=1, admin=0, developer=0, dba=0, sysadm=1, viewer=0 },
    { name = "apple@symplesims.io",    create=1, admin=0, developer=1, dba=1, sysadm=1, viewer=0 },
    { name = "banana@symplesims.io",   create=1, admin=0, developer=1, dba=0, sysadm=1, viewer=0 },
  ]
  //@formatter:on
  policies_admin = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    module.users.MFAForcePolicy_arn
  ]
  policies_sysadm = [
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess",
    "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    module.users.MFAForcePolicy_arn,
    module.users.DenyIPAddressPolicy_arn,
  ]
  policies_developer = [
    "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
    "arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
    "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess",
    "arn:aws:iam::aws:policy/AmazonEMRFullAccessPolicy_v2",
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    module.users.MFAForcePolicy_arn,
    module.users.DenyIPAddressPolicy_arn,
    aws_iam_policy.DenyEC2StopAndTerminationMFAPolicy.arn,
  ]
  policies_dba = [
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    module.users.MFAForcePolicy_arn,
    module.users.DenyIPAddressPolicy_arn,
    aws_iam_policy.DenyRDSLargeCreationPolicy.arn,
  ]
  policies_viewer = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    module.users.MFAForcePolicy_arn,
    module.users.DenyIPAddressPolicy_arn,
  ]
  policy_path = var.policy_path
  deny_ipaddr = [
    "192.0.2.0/24",
    "203.0.113.0/24",
    "62.73.2.131/32"
  ]
}
