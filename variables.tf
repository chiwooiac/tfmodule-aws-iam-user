variable "context" {
  type = object({
    aws_profile = string
    region      = string
    project     = string
    environment = string
    owner       = string
    team        = string
    cost_center = number
    domain      = string
    pri_domain  = string
  })
}

variable "users" {
  description = "User matrix"
  type        = list(object({
    name      = string
    create    = number
    admin     = number
    developer = number
    dba       = number
    sysadm    = number
    viewer    = number
  }))
  default = []
}


variable "policies_admin" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

variable "policies_sysadm" {
  type    = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess",
    "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
}

variable "policies_dba" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AmazonRDSFullAccess"]
}

variable "policies_developer" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"]
}

variable "policies_viewer" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}

variable "policy_path" {
  type    = string
  default = "/"
}

variable "deny_ipaddr" {
  type    = list(string)
  default = []
}
