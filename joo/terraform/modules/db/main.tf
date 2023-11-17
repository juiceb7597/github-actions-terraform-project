#########################################
# RDS
#########################################

resource "aws_db_instance" "postgres" {
  identifier             = var.name
  engine                 = "postgres"
  engine_version         = "15.3"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_encrypted      = true
  db_name                = "postgres"
  username               = jsondecode(data.aws_secretsmanager_secret_version.db-secret.secret_string)["username"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.db-secret.secret_string)["password"]
  port                   = "5432"
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot    = true
  multi_az               = var.multi_az

  tags = merge(
    { "Name" = "${var.name}-postgres" },
    var.tags
  )
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.name}-var.db-subnet-group"
  description = "${var.name}-var.db-subnet-group"
  subnet_ids  = var.subnet_ids

  tags = merge(
    { "Name" = "${var.name}-db-subnet-group" },
    var.tags
  )
}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "db" {
  name        = "${var.name}-db-sg"
  description = "${var.name}-db-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.db_sg_ports
    content {
      description     = "Allow ${ingress.key}"
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [var.was_sg_id]
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
    { "Name" = "${var.name}-db-sg" },
    var.tags
  )
}