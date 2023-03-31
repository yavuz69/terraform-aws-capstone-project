resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.capstone-failover.id
  key    = "index.html"
  source = "../statik-website/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "file_upload2" {
  bucket = aws_s3_bucket.capstone-failover.id
  key    = "sorry.jpg"
  source = "../statik-website/sorry.jpg"
}

