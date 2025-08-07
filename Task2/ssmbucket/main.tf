

## data for an existing s3 bucket
data "aws_s3_bucket" "github_ssh_key_bucket" {
  bucket = "ansible-s3-bucket-omokaro" # Replace with your actual S3 bucket name
}



