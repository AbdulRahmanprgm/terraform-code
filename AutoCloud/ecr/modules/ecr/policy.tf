resource "aws_ecr_repository_policy" "ecs_pull_only" {
  for_each = aws_ecr_repository.this

  repository = each.value.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowECSAndCodeDeployPull"
        Effect    = "Allow"
        Principal = { Service = ["ecs-tasks.amazonaws.com", "codedeploy.amazonaws.com"] }
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
      }
    ]
  })
}
