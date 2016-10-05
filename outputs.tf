output "alb_hostname" {
  value = "${aws_alb.main.dns_name}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "nodes" {
  value = ["${aws_instance.node.*.tags.Name}"]
}
