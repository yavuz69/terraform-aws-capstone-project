resource "aws_iam_policy" "capstone_bucket_policy" {
  name        = "capstone_bucket_policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::byawsblog-terraform"
        ]
      }
    ]
  })
  tags = {
    tag-key = "terraform-capstone-policy"
   }
}

resource "aws_iam_role" "capstone_some_role" {
  name = "capstone_some_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
   tags = {
    tag-key = "terraform-capstone-role"
   }
}

resource "aws_iam_role_policy_attachment" "some_bucket_policy" {
  role       = aws_iam_role.capstone_some_role.name
  policy_arn = aws_iam_policy.capstone_bucket_policy.arn
}

resource "aws_iam_instance_profile" "capstone_some_profile" {
  name = "some-profile"
  role = aws_iam_role.capstone_some_role.name
}

# resource "aws_iam_role" "example" {
#   name = "example-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "example" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#   role       = aws_iam_role.example.name
# }

# data "aws_iam_policy_document" "example" {
#   statement {
#     effect  = "Allow"
#     actions = ["s3:*"]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "example" {
#   name        = "example-policy"
#   policy      = data.aws_iam_policy_document.example.json
# }



