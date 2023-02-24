module "ctx" {
  source  = "git::https://github.com/chiwooiac/tfmodule-context.git"
  context = var.context
}

locals {
  project       = module.ctx.project
  region        = module.ctx.region
  tags          = module.ctx.tags
  name_prefix   = module.ctx.name_prefix
  users_create = [for u in var.users : u.name if u.create == 1]
}

resource "aws_iam_user" "this" {
  count         = length(local.users_create)
  name          = element(local.users_create, count.index )
  path          = "/"
  force_destroy = true
  tags          = local.tags
}
