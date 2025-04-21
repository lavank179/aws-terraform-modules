module "host-webapp" {
  source         = "./s3-with-cloudfront"
  s3_bucket_name = var.s3_bucket_name
  index_page = var.index_page
  environment    = var.environment
}
