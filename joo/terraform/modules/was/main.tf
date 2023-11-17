################################################################################
# Launch template
################################################################################

resource "aws_launch_template" "was" {
  name          = "${var.name}-was-launch-template"
  description   = "${var.name}-was-launch-template"
  instance_type = var.instance_type
  image_id      = data.aws_ami.ubuntu.id
  key_name      = var.key_name
  user_data     = filebase64("${path.module}/was-install.sh")

  vpc_security_group_ids = aws_security_group.was[*].id

  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }

  tags = merge(
    { "Name" = "${var.name}-was-launch-template" },
    var.tags
  )
}
################################################################################
# Autoscaling group
################################################################################

resource "aws_autoscaling_group" "was" {
  name = "${var.name}-was-asg"

  launch_template {
    id = aws_launch_template.was.id
  }

  vpc_zone_identifier       = var.vpc_zone_identifier
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  target_group_arns         = [var.target_group_arns]
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  tag {
    key                 = "Name"
    value               = "${var.name}-was"
    propagate_at_launch = true
  }

  tag {
    key                 = keys(var.tags)[0]
    value               = lookup(var.tags, "owner")
    propagate_at_launch = true
  }
}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "was" {
  name        = "${var.name}-was-sg"
  description = "${var.name}-was-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.was_sg_ports
    content {
      description     = "Allow ${ingress.key}"
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [var.private_lb_sg_id]
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
    { "Name" = "${var.name}-was-sg" },
    var.tags
  )
}