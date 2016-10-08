resource "aws_iam_role" "ecs_host_role" {
  name               = "${var.prefix}.host_role"
  assume_role_policy = "${file("${path.module}/policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "${var.prefix}.instance_role_policy"
  policy = "${file("${path.module}/policies/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.ecs_host_role.id}"
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "${var.prefix}.service_role"
  assume_role_policy = "${file("${path.module}/policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.prefix}.service_role_policy"
  policy = "${file("${path.module}/policies/ecs-service-role-policy.json")}"
  role   = "${aws_iam_role.ecs_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
  name  = "${var.prefix}.instance-profile"
  path  = "/"
  roles = ["${aws_iam_role.ecs_host_role.name}"]
}
