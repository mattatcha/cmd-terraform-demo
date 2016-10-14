output "cluster_name" {
  value = "${aws_ecs_cluster.main.name}"
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

output "subnets" {
  value = ["${aws_subnet.main.*.id}"]
}
