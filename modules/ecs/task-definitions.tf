resource "aws_ecs_task_definition" "service" {
  family = "nginx"
  container_definitions = <<TASK_DEFINITION
[
  {
      "name": "nginx",
      "image": "nginx:latest",
      "memory": 256,
      "cpu": 256,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "awslogs-nginx-ecs",
              "awslogs-region": "us-east-1",
              "awslogs-stream-prefix": "nginx"
          }
      }
    }
]
  TASK_DEFINITION

  depends_on = ["aws_ecs_cluster.my-test-ecs"]
}
