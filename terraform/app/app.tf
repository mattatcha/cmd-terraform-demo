resource "aws_alb" "main" {
  name            = "${var.cluster}-${var.app}-alb"
  subnets         = ["${var.subnets}"]
  security_groups = ["${aws_security_group.default.id}"]
}

resource "aws_alb_target_group" "80" {
  name                 = "${var.cluster}-${var.app}-tg-80"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc}"
  deregistration_delay = 5
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.80.arn}"
    type             = "forward"
  }
}

resource "aws_security_group" "default" {
  name   = "${var.cluster}.${var.app}.sg.lb"
  vpc_id = "${var.vpc}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
