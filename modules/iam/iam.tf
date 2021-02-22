resource "aws_iam_role" "ecs-role" {
	name        = "my-ecs-iam-role"
	path        = "/"
	assume_role_policy = "${file("modules/iam/files/ecs2_ecs_role_policy.json")}"

	tags = {
        Name            = "${lower(var.name)}-iam"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name  = "ec2_instance_profile"
  role = "${aws_iam_role.ecs-role.name}"
}
