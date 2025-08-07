### s3 Bucket name

resource "aws_s3_bucket" "visible_bucket" {
  bucket         = var.bucket_name
  force_destroy  = true

  tags = {
    Name = "PrivateBucket"
  }
}


##### this allow the blocked restriction
resource "aws_s3_bucket_public_access_block" "private_access_block" {
  bucket = aws_s3_bucket.visible_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}



####### IAM Policy to list but not able to dekete
resource "aws_iam_policy" "list_only_no_object_access" {
  name        = "S3ListOnlyNoObjectAccess"
  description = "Allow listing bucket, deny object-level access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowListBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "${aws_s3_bucket.visible_bucket.arn}"
      },
      {
        Sid    = "DenyAllObjectActions"
        Effect = "Deny"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.visible_bucket.arn}/*"
      }
    ]
  })
}



##### creating a user
resource "aws_iam_user" "bucket_user" {
  name = "s3-visible-bucket-user"
}


####### Attach Policy to the IAM User
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.bucket_user.name
  policy_arn = aws_iam_policy.s3_get_put_only.arn
}
