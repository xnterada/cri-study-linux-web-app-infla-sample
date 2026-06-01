# ステートマシン用IAMロール作成
resource "aws_iam_role" "sfn" {
  name = "${var.project_name}-${var.environment}-iam-role-sfn"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

# ステートマシン用IAMポリシー作成
resource "aws_iam_role_policy" "sfn" {
  name = "${var.project_name}-${var.environment}-iam-policy-sfn"
  role = aws_iam_role.sfn.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:GetHealthCheck",
          "route53:UpdateHealthCheck"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# サーバー起動用のワークフロー
resource "aws_sfn_state_machine" "start_server" {
  name     = "${var.project_name}-${var.environment}-sfn-start-server"
  role_arn = aws_iam_role.sfn.arn
  definition = templatefile("${path.module}/templates/start_server.json", {
    domain_name     = var.domain_name
    health_check_id = var.health_check_id
    hosted_zone_id  = var.hosted_zone_id
  })
}

# サーバー停止用のワークフロー
resource "aws_sfn_state_machine" "stop_server" {
  name       = "${var.project_name}-${var.environment}-sfn-stop-server"
  role_arn   = aws_iam_role.sfn.arn
  definition = file("${path.module}/templates/stop_server.json")
}

# 定期起動設定
resource "aws_scheduler_schedule_group" "this" {
  name = "${var.project_name}-${var.environment}-scheduler-group"
}

resource "aws_scheduler_schedule" "start_server" {
  name       = "${var.project_name}-${var.environment}-scheduler-start"
  group_name = aws_scheduler_schedule_group.this.name

  flexible_time_window {
    mode = "OFF"
  }

  # 日本時間 09:00
  schedule_expression          = "cron(0 9 * * ? *)"
  schedule_expression_timezone = "Asia/Tokyo"

  target {
    arn      = aws_sfn_state_machine.start_server.arn
    role_arn = aws_iam_role.scheduler.arn
    input = jsonencode({
      InstanceIds = var.instance_ids
    })
  }
}

# 定期停止設定
resource "aws_scheduler_schedule" "stop_server" {
  name       = "${var.project_name}-${var.environment}-scheduler-stop"
  group_name = aws_scheduler_schedule_group.this.name

  flexible_time_window {
    mode = "OFF"
  }

  # 日本時間 23:00
  schedule_expression          = "cron(0 23 * * ? *)"
  schedule_expression_timezone = "Asia/Tokyo"

  target {
    arn      = aws_sfn_state_machine.stop_server.arn
    role_arn = aws_iam_role.scheduler.arn
    input = jsonencode({
      InstanceIds = var.instance_ids
    })
  }
}

# スケジューラ用のIAMロール作成
resource "aws_iam_role" "scheduler" {
  name = "${var.project_name}-${var.environment}-iam-role-scheduler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
    }]
  })
}

# スケジューラ用IAMポリシー作成
resource "aws_iam_role_policy" "scheduler" {
  name = "${var.project_name}-${var.environment}-iam-policy-scheduler"
  role = aws_iam_role.scheduler.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "states:StartExecution"
      Effect = "Allow"
      Resource = [
        aws_sfn_state_machine.start_server.arn,
        aws_sfn_state_machine.stop_server.arn
      ]
    }]
  })
}
