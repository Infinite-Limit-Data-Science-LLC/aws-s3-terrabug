resource "aws_s3_bucket" "mybucket" {
  bucket                   = "${var.bucket_name}-${var.region}"
  force_destroy            = true
  policy                   = data.aws_iam_policy_document.bucket_policy.json
  acl                      = "private"

  versioning {
    enabled = true
  }

  dynamic "server_side_encryption_configuration" {
    for_each = length(var.kms_key_arn) > 0 ? ["KMS"] : []
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = var.kms_key_arn
          sse_algorithm     = "aws:kms"
        }

        bucket_key_enabled  = true
      }
    }
  }

  dynamic "replication_configuration" {
    for_each = var.replication_enabled ? ["replication_enabled"] : []
    content {
      role = var.execution_role_arn

      rules {
        id       = "${var.bucket_name}-${var.region}_to_${var.bucket_name}-${var.replication_region}"
        priority = 0
        status   = "Enabled"

        destination {
          bucket             = "arn:aws:s3:::${var.bucket_name}-${var.replication_region}"
          storage_class      = "STANDARD"
          replica_kms_key_id = var.replication_kms_key_arn
        }

        dynamic "source_selection_criteria" {
          for_each = length(var.kms_key_arn) > 0 ? ["KMS"] : []
          content {
            sse_kms_encrypted_objects {
              enabled = true
            }
          }
        }
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls         = true
  block_public_policy       = true
  restrict_public_buckets   = true
  ignore_public_acls        = true
}

data "aws_iam_policy_document" "bucket_policy" {
  version         = "2012-10-17"

  statement {
    sid           = "DenyIncorrectEncryptionHeader"
    effect        = "Deny"
    actions       = ["s3:PutObject"]
    resources     = ["arn:aws:s3:::${var.bucket_name}-${var.region}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
    
    condition {
      test        = "StringNotEquals"
      variable    = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values      = [var.kms_key_arn]
    }
  }

  statement {
    sid           = "DenyUnencryptedObjectUploads"
    effect        = "Deny"
    actions       = ["s3:PutObject"]
    resources     = ["arn:aws:s3:::${var.bucket_name}-${var.region}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test        = "Null"
      variable    = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values      = ["true"]
    }
  }
}