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

locals {
  name_suffix         = length(var.name_suffix) > 0 ? "-${var.name_suffix}" : ""
}

data "aws_iam_policy_document" "execution_role" {
  version             = "2012-10-17"

  statement {
    sid               = "AssumeRole"
    effect            = "Allow"
    actions           = ["sts:AssumeRole"]

    principals {
      type            = "Service"
      identifiers     = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution_role" {
  assume_role_policy    = data.aws_iam_policy_document.execution_role.json
  name                  = "${var.name_prefix}-bucket-execution-role${local.name_suffix}"
}

data "aws_iam_policy_document" "task_policy" {
  version             = "2012-10-17"

  statement {
    sid               = "CrossRegionReplication"
    effect            = "Allow"
    actions           = ["s3:GetObjectVersion", "s3:GetObjectVersionACL"]
    resources         = ["*"]
  }
}

resource "aws_iam_policy" "task_policy" {
  name                = "${var.name_prefix}-bucket-access${local.name_suffix}"
  description         = "bucket access"
  policy              = data.aws_iam_policy_document.task_policy.json
}

resource "aws_iam_role_policy_attachment" "execution_role" {
  role                = aws_iam_role.execution_role.name
  policy_arn          = aws_iam_policy.task_policy.arn
}