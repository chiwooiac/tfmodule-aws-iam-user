terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.50.0"
    }
  }
}

# Refers to environment variables [AWS_PROFILE, AWS_REGION].
provider "aws" {
  region = module.ctx.region
}
