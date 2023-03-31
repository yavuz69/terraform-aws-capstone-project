resource "aws_s3_bucket" "capstone" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account_bucket" {
  bucket = aws_s3_bucket.capstone.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account_bucket.json
}

data "aws_iam_policy_document" "allow_access_from_another_account_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.capstone.arn,
      "${aws_s3_bucket.capstone.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "capstone_public" {
  bucket = aws_s3_bucket.capstone.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}