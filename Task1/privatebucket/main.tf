### s3 Bucket name

resource "aws_s3_bucket" "private_bucket" {
  bucket         = var.bucket_name
  force_destroy  = true

  tags = {
    Name = "PrivateBucket"
  }
}


##### this allow the blocked restriction
resource "aws_s3_bucket_public_access_block" "private_access_block" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}



####### IAM Policy to Allow Get and Put (but Not Delete)
resource "aws_iam_policy" "s3_get_put_only" {
  name        = "S3GetPutOnlyPolicy"
  description = "Allows GetObject and PutObject, denies DeleteObject"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowGetPut"
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.private_bucket.arn}/*"
      },
      {
        Sid    = "ExplicitDenyDelete"
        Effect = "Deny"
        Action = [
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.private_bucket.arn}/*"
      }
    ]
  })
}


##### creating a user
resource "aws_iam_user" "bucket_user" {
  name = "s3-private-bucket-user"
}


####### Attach Policy to the IAM User
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.bucket_user.name
  policy_arn = aws_iam_policy.s3_get_put_only.arn
}
