terraform {
  required_providers {
    aws = {
      version = "= 3.74.1"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

provider "aws" {
  region  = "us-west-2"
  alias   = "secondary_region"
}

module "account_settings" {
  source = "git::git@github.com:Infinite-Limit-Data-Science-LLC/aws-bootstrap.git//infrastructure//data-sources?ref=v1.1"
}

module "iam" {
  source        = "../../infrastructure/iam"
  name_prefix   = var.name
  name_suffix   = var.name_suffix
}

module "bucket_or_buckets" {
  source                    = "../../infrastructure"
  bucket_name               = var.bucket_name
  replication_enabled       = var.replication_enabled
  region                    = "us-east-1"
  replication_region        = "us-west-2"
  kms_key_arn               = module.account_settings.kms_key_arn_primary
  replication_kms_key_arn   = module.account_settings.kms_key_arn_secondary
  execution_role_arn        = module.iam.execution_role_arn
}