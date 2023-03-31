resource "aws_s3_bucket" "capstone-failover" {
  bucket = var.s3_bucket_name_failover
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.capstone-failover.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
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
      aws_s3_bucket.capstone-failover.arn,
      "${aws_s3_bucket.capstone-failover.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "capstone-failover_website" {
  bucket = aws_s3_bucket.capstone-failover.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_public_access_block" "capstone-failover_public" {
  bucket = aws_s3_bucket.capstone-failover.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}