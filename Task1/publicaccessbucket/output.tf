#### s3 static website url
# output "website_url" {
#   description = "URL of the hosted static website"
#   value       = aws_s3_bucket.static_site.website_endpoint
# }

output "website_url_config" {
  value = "http://${aws_s3_bucket_website_configuration.static_site_website.website_endpoint}"
  description = "URL of the static website"
}


output "cloudfront_domain_url" {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}