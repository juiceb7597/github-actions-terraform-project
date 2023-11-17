################################################################################
# Load Balancer
################################################################################

resource "aws_lb" "private" {
  internal           = true
  load_balancer_type = var.load_balancer_type
  name               = "${var.name}-private-lb"
  security_groups    = [aws_security_group.private_lb.id]
  subnets            = var.private_lb_subnets
  tags = merge(
    { "Name" = "${var.name}-private-lb" },
    var.tags
  )
}

################################################################################
# Listener(s)
################################################################################

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.private.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.was.arn
  }

  tags = merge(
    { "Name" = "${var.name}-private-lb-Listener" },
    var.tags
  )
}

################################################################################
# Target Group(s)
################################################################################

resource "aws_lb_target_group" "was" {

  name     = "was-TG"
  port     = 8000
  protocol = "HTTP"

  vpc_id = var.vpc_id

  tags = merge(
    { "Name" = "${var.name}-was-TG" },
    var.tags
  )
}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "private_lb" {
  name        = "${var.name}-private-lb-sg"
  description = "${var.name}-private-lb-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.private_lb_sg_ports
    content {
      description     = "Allow ${ingress.key}"
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [var.web_sg_id]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    { "Name" = "${var.name}-private-lb-sg" },
    var.tags
  )
}