resource "aws_iam_role" "my_ecs_role" {
  name = "my_ecs_role"

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
}

resource "aws_iam_role_policy" "my_ecs_policy" {
  name = "my-ecs-iam-policy"
  role = aws_iam_role.my_ecs_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
	Version = "2012-10-17"
    Statement = [
    	{
 	    Sid = ""
            Effect = "Allow"
            Action = [
            	"ec2:DescribeTags",
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:UpdateContainerInstancesState",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
            Resource = "*"
        },
        ]
    })
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name  = "ec2_instance_profile"
  role = "${aws_iam_role.my_ecs_role.name}"
}
