################################################################################
# Load Balancer
################################################################################

resource "aws_lb" "public" {
  load_balancer_type = var.load_balancer_type
  name               = "${var.name}-public-lb"
  security_groups    = [aws_security_group.public_lb.id]
  subnets            = var.public_lb_subnets
  tags = merge(
    { "Name" = "${var.name}-public-lb" },
    var.tags
  )
}

################################################################################
# Listener(s)
################################################################################

resource "aws_lb_listener" "https" {
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn
  load_balancer_arn = aws_lb.public.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  tags = merge(
    { "Name" = "${var.name}-public-lb-https-Listener" },
    var.tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(
    { "Name" = "${var.name}-public-lb-http-Listener" },
    var.tags
  )
}

################################################################################
# Target Group(s)
################################################################################

resource "aws_lb_target_group" "web" {

  name     = "web-TG"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  tags = merge(
    { "Name" = "${var.name}-web-TG" },
    var.tags
  )
}


################################################################################
# Security Group
################################################################################

resource "aws_security_group" "public_lb" {
  name        = "${var.name}-public-lb-sg"
  description = "${var.name}-public-lb-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.public_lb_sg_ports
    content {
      description = "Allow ${ingress.key}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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
    { "Name" = "${var.name}-public-lb-sg" },
    var.tags
  )
}