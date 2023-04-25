# export the ecs service
output "ecs_service" {
  value = aws_ecs_service.ecs_service
}

# export the ecs service
output "ecs_cluster" {
  value = aws_ecs_cluster.ecs_cluster
}

