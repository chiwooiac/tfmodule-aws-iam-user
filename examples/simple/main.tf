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

module "users" {
  source  = "../../"
  context = module.ctx.context
  //@formatter:off
  users = [
    { name = "admin@symplesims.io",    create=1, admin=1, developer=0, dba=0, sysadm=0, viewer=1 },
    { name = "manager@symplesims.io",  create=1, admin=1, developer=0, dba=0, sysadm=1, viewer=1 },
    { name = "devlamp@symplesims.io",  create=1, admin=0, developer=1, dba=0, sysadm=0, viewer=1 },
    { name = "devapple@symplesims.io", create=1, admin=0, developer=1, dba=0, sysadm=0, viewer=1 },
    { name = "scott@symplesims.io",    create=1, admin=0, developer=0, dba=1, sysadm=0, viewer=1 },
    { name = "tiger@symplesims.io",    create=1, admin=0, developer=0, dba=1, sysadm=0, viewer=1 },
    { name = "viewer@symplesims.io",   create=1, admin=0, developer=0, dba=0, sysadm=0, viewer=1 },
    { name = "reporter@symplesims.io", create=1, admin=0, developer=0, dba=0, sysadm=0, viewer=1 },
    { name = "cfalron@symplesims.io",  create=1, admin=0, developer=0, dba=0, sysadm=0, viewer=1 },
    { name = "apple@symplesims.io",    create=1, admin=0, developer=1, dba=1, sysadm=1, viewer=1 },
    { name = "banana@symplesims.io",   create=1, admin=0, developer=1, dba=1, sysadm=1, viewer=1 },
  ]
  //@formatter:on
  policies_admin = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  policies_sysadm    = ["arn:aws:iam::aws:policy/AmazonRoute53FullAccess"]
  policies_developer = ["arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"]
  policies_dba       = ["arn:aws:iam::aws:policy/AmazonRDSFullAccess"]
  policies_viewer    = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}
