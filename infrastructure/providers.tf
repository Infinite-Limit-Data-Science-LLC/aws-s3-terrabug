terraform {
  required_providers {
    aws = {
      version = "= 3.74.1"
      source  = "hashicorp/aws"
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