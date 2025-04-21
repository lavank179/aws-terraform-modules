# Origin Access Identity for CloudFront
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Access S3 through CloudFront only"
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.webapp-artifacts.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.webapp-artifacts.id
    
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.webapp-artifacts.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_100" // Use only North America and Europe

  # web_acl_id = aws_wafv2_web_acl.allow_only_ips.arn
}