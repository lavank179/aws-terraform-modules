resource "aws_s3_bucket" "webapp-artifacts" {
  bucket = var.s3_bucket_name
  tags = {
    Name = var.s3_bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "public-access-block" {
  bucket = aws_s3_bucket.webapp-artifacts.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}


# S3 Bucket Policy to allow only CloudFront
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.webapp-artifacts.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          AWS = "${aws_cloudfront_origin_access_identity.oai.iam_arn}"
        }
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.webapp-artifacts.arn}/*"
      }
    ]
  })

  depends_on = [ aws_s3_bucket_public_access_block.public-access-block ]
}