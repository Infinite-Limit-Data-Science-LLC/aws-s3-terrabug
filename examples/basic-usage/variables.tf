variable "name" {
  type            = string
  description     = "name"
  default         = "unit"
}

variable "name_suffix" {
  type            = string
  description     = "name suffix"
  default         = "white-kitten"
}

variable "bucket_name" {
  type            = string
  description     = "bucket name"
  default         = "scrapetorium-upload-sandbox-test"
}
# ---------------------------------------------------------------------------------------------------------------------
# Replication
# These variables are used for Replication.
# ---------------------------------------------------------------------------------------------------------------------

variable "replication_enabled" {
  type            = bool
  description     = "replication enabled"
  default         = true
}
