output "alb_hostname" {
  value = "${aws_alb.main.dns_name}"
}

output "alb_name" {
  value = "${aws_alb.main.name}"
}

output "target_group" {
  value = "${aws_alb_target_group.80.arn}"
}
