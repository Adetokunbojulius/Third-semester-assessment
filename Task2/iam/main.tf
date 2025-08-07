### CREATE A ROLE ###
resource "aws_iam_role" "ssm_ec2_role" {
  name = "${var.project}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project}-ec2-ssm-role"
  }
}

### ATTACH SSM MANAGED POLICY ###
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



### ADD INLINE POLICY FOR S3 BUCKET ACCESS ###
resource "aws_iam_policy" "ssm_s3_access" {
  name        = "${var.project}-ssm-s3-policy"
  description = "Allow SSM to use the Ansible S3 bucket"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::ansible-ssm-bucket-omokaro",
          "arn:aws:s3:::ansible-ssm-bucket-omokaro/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm_s3" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = aws_iam_policy.ssm_s3_access.arn
}


### 4. Attach AWS-Managed RDS Policy full access###
resource "aws_iam_role_policy_attachment" "ssm_rds" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
