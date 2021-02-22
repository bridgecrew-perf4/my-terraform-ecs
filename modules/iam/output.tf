output "iam-arn" {
	value = "${aws_iam_role.my_ecs_role.arn}"
}

output "iam-profile-name" {
	value = "${aws_iam_instance_profile.ec2_instance_profile.name}"
}
