module "bucket" {
  source                    = "./s3"
  bucket_name               = var.bucket_name
  region                    = var.region
  replication_region        = var.replication_region
  replication_enabled       = var.replication_enabled
  kms_key_arn               = var.kms_key_arn
  replication_kms_key_arn   = var.replication_kms_key_arn
  execution_role_arn        = var.execution_role_arn

  depends_on                = [module.replication_bucket[0]]

  providers = {
    aws = "aws"
  }
}

module "replication_bucket" {
  source                    = "./s3"
  count                     = var.replication_enabled ? 1 : 0
  bucket_name               = var.bucket_name
  region                    = var.replication_region
  replication_region        = ""
  replication_enabled       = false
  kms_key_arn               = var.replication_kms_key_arn
  replication_kms_key_arn   = ""
  execution_role_arn        = var.execution_role_arn

  providers                 = {
    aws = "aws.secondary_region"
  } 
}