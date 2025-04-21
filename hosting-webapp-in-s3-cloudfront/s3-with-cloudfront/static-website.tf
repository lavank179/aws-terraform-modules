locals {
  uploads_path = "${path.module}/uploads"

  mime_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    gif  = "image/gif"
    svg  = "image/svg+xml"
    ico  = "image/x-icon"
  }
}

resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.webapp-artifacts.bucket

index_document {
    suffix = var.index_page
  }
error_document {
    key = "error.html"
  }

#IF you want to use the routing rule, modify below.
# routing_rule {
#     condition {
#       key_prefix_equals = "/abc"
#     }
#     redirect {
#       replace_key_prefix_with = "comming-soon.jpeg"
#     }
#   }
}

# copy all files to s3 from uploads/ folder.
resource "aws_s3_object" "object-upload-html" {
    for_each        = fileset(local.uploads_path, "*.*")
    bucket          = aws_s3_bucket.webapp-artifacts.id
    key             = each.value
    source          = "${local.uploads_path}/${each.value}"
    etag            = filemd5("${local.uploads_path}/${each.value}")

    content_type = lookup(
      local.mime_types,
      lower(trimspace(element(split(".", each.value), length(split(".", each.value)) - 1))),
      "binary/octet-stream"
    )
}
