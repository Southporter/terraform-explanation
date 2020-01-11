########################################################
# Notice
# There is no provider block in a module.
# This is because the code calling the module should
# specify the provider.
########################################################





data "aws_ami" "ami_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-20*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"
  vars {
    db_url = aws_rds_cluster.webserver_database_cluster.endpoint
  }

  depends_on = [aws_rds_cluster.webserver_database_cluster]
}

resource "aws_instance" "webserver" {
  ami           = data.aws_ami.ami_latest.id
  instance_type = var.instance_type

  user_data = "${data.template_file.user_data.renderer}"

  tags = merge(var.tags, {
    "Name" = var.server_name
  }
}

resource "aws_security_group" "web_ingress" {
  name        = "${var.server_name}-ingress"
  description = "Allow ingress on 22 (ssh), 80 (http), 443 (https). Allow egress on all ports."
  vpc_id      = var.aws_vpc

  ingress {
    from_port = 22
    to_port   = 22
    protoco   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port   = 80
    protoco   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protoco   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    "Name" = "${var.server_name}-security-group"
  })
}

data "aws_route53_zone" "selected" {
  name         = var.dns_zone
  private_zone = var.is_private
}

resource "aws_route53_record" "dns_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.dns_subdomain}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = var.dns_ttl
  records = [aws_instance.webserver.private_ip]
}


