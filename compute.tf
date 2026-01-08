
resource "aws_ecr_repository" "runner" {
  name                 = "${var.proj_name}-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true # dev mode, remove later

  image_scanning_configuration {
    scan_on_push = true # monitoring
  }
}
resource "aws_ecs_cluster" "cluster" {
  name = "${var.proj_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
resource "aws_ecs_cluster_capacity_providers" "cap_prov" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }

  default_capacity_provider_strategy { #i might not need this but i have it here as backup to the spot instance
    weight            = 0
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "runner" {
  family                   = "${var.proj_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024 #might make this smaller later
  memory                   = 2048

  execution_role_arn = aws_iam_role.ecs_exec.arn
  task_role_arn      = aws_iam_role.ecs_exec.arn

  container_definitions = jsonencode([{}]) ## i cant terraform plan without this, ill sort this out more when i know more about how im doing the docker stuff
}
