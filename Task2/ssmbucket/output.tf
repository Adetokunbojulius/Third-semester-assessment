###ssmbucket output file
output "ssm_bucket_name" {
  value = data.aws_s3_bucket.github_ssh_key_bucket.bucket
}

output "ssm_bucket_arn" {
  value = data.aws_s3_bucket.github_ssh_key_bucket.arn
}

