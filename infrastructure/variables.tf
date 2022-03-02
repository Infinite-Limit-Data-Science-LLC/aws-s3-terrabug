variable "bucket_name" {
  type            = string
  description     = "bucket name"
}

variable "region" {
  type            = string
  description     = "region"
}

variable "replication_region" {
  type            = string
  description     = "replication region"
  default         = ""
}

variable "kms_key_arn" {
  type            = string
  description     = "kms key arn"
}

variable "replication_enabled" {
  type            = bool
  description     = "replication enabled"
}

variable "replication_kms_key_arn" {
  type            = string
  description     = "replication kms key arn"
  default         = ""
}

variable "execution_role_arn" {
  type            = string
  description     = "role arn"
}