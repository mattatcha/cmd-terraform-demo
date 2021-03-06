provider "aws" {
  region = "${var.aws_region}"
}

data "aws_availability_zones" "available" {}

resource "aws_ecs_cluster" "main" {
  name = "${var.name}"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "${var.name}.vpc"
  }
}

resource "aws_subnet" "main" {
  count                   = 2
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name}.sub.${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}.ig"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  gateway_id             = "${aws_internet_gateway.gw.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_security_group" "default" {
  name   = "${var.name}.sg.default"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "node" {
  count                = "${var.count}"
  ami                  = "${data.aws_ami.coreos.id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  user_data            = "${data.template_file.cloud_config.rendered}"
  subnet_id            = "${element(aws_subnet.main.*.id, count.index)}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"

  vpc_security_group_ids = [
    "${aws_security_group.default.id}",
  ]

  tags {
    Name = "${var.name}.node.${count.index}"
  }
}

data "aws_ami" "coreos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["595879546273"] # CoreOS
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config.yaml")}"

  vars {
    aws_region         = "${var.aws_region}"
    ecs_cluster_name   = "${aws_ecs_cluster.main.name}"
    ecs_log_level      = "info"
    ecs_agent_version  = "latest"
    ecs_log_group_name = "${aws_cloudwatch_log_group.ecs.name}"
  }
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "${var.name}.cluster/agent"
}
