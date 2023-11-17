#########################################
# IAM
#########################################

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role_ECR"

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

  tags = merge(
    { "Name" = "${var.name}-ec2-role" },
    var.tags
  )
}

resource "aws_iam_instance_profile" "this" {
  role = aws_iam_role.ec2_role.name

  name = "EC2InstanceProfileECR"
  path = "/"

  tags = merge(
    { "Name" = "${var.name}-instance-profile-ecr" },
    var.tags
  )
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr-policy"
  path        = "/"
  description = "ecr policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr-public:GetAuthorizationToken",
          "sts:GetServiceBearerToken",
          "ecr-public:BatchCheckLayerAvailability",
          "ecr-public:GetRepositoryPolicy",
          "ecr-public:DescribeRepositories",
          "ecr-public:DescribeRegistries",
          "ecr-public:DescribeImages",
          "ecr-public:DescribeImageTags",
          "ecr-public:GetRepositoryCatalogData",
          "ecr-public:GetRegistryCatalogData",
          "ecr-public:InitiateLayerUpload",
          "ecr-public:UploadLayerPart",
          "ecr-public:CompleteLayerUpload",
          "ecr-public:PutImage"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_role" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}