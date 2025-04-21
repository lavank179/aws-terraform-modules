variable "s3_bucket_name" {
  default = "webapp-artifacts"
}

variable "environment" {
  default = "test"
}

variable "aws_region" {}

variable "index_page" {
  default = "index.html"
}