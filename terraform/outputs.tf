output "cluster_name" {
  value = "${aws_ecs_cluster.main.name}"
}

output "alb_hostname" {
  value = "${aws_alb.main.dns_name}"
}

output "alb_name" {
  value = "${aws_alb.main.name}"
}

output "target_group" {
  value = "${aws_alb_target_group.80.arn}"
}

output "service_role" {
  value = "${aws_iam_role.ecs_service_role.arn}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "nodes" {
  value = ["${aws_instance.node.*.tags.Name}"]
}
