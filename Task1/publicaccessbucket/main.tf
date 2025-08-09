###simple static website



##### s3 Bucket
resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name
  force_destroy = true
  region = var.aws_region

  tags = {
    Name        = "StaticWebsite"
    # Environment = "Dev"
  }

  
}


###### enables static website hosting:
resource "aws_s3_bucket_website_configuration" "static_site_website" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

####### Bucket public access

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}




############ Bucket Policy with getObject from the bucket
# resource "aws_s3_bucket_policy" "public_read_policy" {
#   bucket = aws_s3_bucket.static_site.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = "*",
#       Action = ["s3:GetObject"],
#       Resource = "${aws_s3_bucket.static_site.arn}/*"
#     }]
#   })
# }

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.static_site.id
  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}




resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "error.html"
  source       = "${path.module}/error.html"
  content_type = "text/html"
}




### Adding cloudfront to the bucket
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.static_site.id}"
  }

  default_cache_behavior {
    target_origin_id       = "S3-${aws_s3_bucket.static_site.id}"
    viewer_protocol_policy = "allow-all" # Allow HTTP and HTTPS
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true # Needed even for HTTP
  }
}
