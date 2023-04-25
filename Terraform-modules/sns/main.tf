# Create an SNS topic
resource "aws_sns_topic" "elearning_updates" {
  name = "${var.project_name}-${var.environment}-topic"
}

# Create an SNS topic for autoscaling notification
resource "aws_sns_topic" "autoscaling_notification" {
  name = "${var.project_name}-${var.environment}-notification"
}

# Create an SNS Topic Subscription
resource "aws_sns_topic_subscription" "elearning_notification_email" {
  topic_arn = aws_sns_topic.elearning_updates.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}

# Create a policy to allow CloudWatch to publish to the SNS topic
resource "aws_sns_topic_policy" "sns_policy" {
  arn = aws_sns_topic.elearning_updates.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        #Sid = "__default_statement_ID"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action = [
          "SNS:Publish"
        ]
        Resource = aws_sns_topic.elearning_updates.arn
      }
    ]
  })
}

#
resource "aws_cloudwatch_metric_alarm" "ecs_metric_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-ecs_metric_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when ECS MemoryUtilization exceeds 80%"
  
  dimensions = {
    ClusterName    = var.ecs_cluster.name
    ServiceName    = var.ecs_service.name
  }

  alarm_actions = [
    aws_sns_topic.elearning_updates.arn
  ]
}



