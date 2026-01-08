resource "aws_iam_role" "ecs_exec" {
  name = "${var.proj_name}-ecs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.proj_name}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}
resource "aws_iam_role_policy" "ecs_ssm" {
  name = "ssm-access"
  role = aws_iam_role.ecs_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ssm:GetParameters", "ssm:GetParameter"]
      Resource = "arn:aws:ssm:ap-southeast-2:*:parameter/github-runner/*"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_perms" {
  name = "lambda-perms"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecs:RunTask"]
        Resource = "*" # TODO: lock down to task def arn later
      },
      {
        Effect   = "Allow"
        Action   = ["iam:PassRole"]
        Resource = aws_iam_role.ecs_exec.arn
      },
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameter", "ssm:GetParameters"]
        Resource = "arn:aws:ssm:ap-southeast-2:*:parameter/github-runner/*"
      }
    ]
  })
}
