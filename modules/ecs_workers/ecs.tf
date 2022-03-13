resource "aws_ecs_cluster" "my-test-ecs" {
  name = "${var.name}-${var.environment}-${var.ecs-cluster-name}"
}
