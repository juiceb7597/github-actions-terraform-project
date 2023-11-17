################################################################################
# VPC
################################################################################

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = merge(
    { "Name" = "${var.name}-vpc" },
    var.tags
  )
}

################################################################################
# Publiс Subnets
################################################################################

resource "aws_subnet" "public" {
  count = 2

  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.public_subnet_cidr, count.index)
  tags = merge(
    { "Name" = "${var.name}-${element(var.azs, count.index)}-public-subnet" },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    { "Name" = "${var.name}-${var.azs[0]}-public-route-table" },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

################################################################################
# WEB Subnets
################################################################################

resource "aws_subnet" "web" {
  count = 2

  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.web_subnet_cidr, count.index)

  tags = merge(
    { "Name" = "${var.name}-${element(var.azs, count.index)}-web-subnet" },
    var.tags
  )
}

resource "aws_route_table" "web" {
  count = 2

  vpc_id = aws_vpc.main.id
  tags = merge(
    { "Name" = "${var.name}-${element(var.azs, count.index)}-private-route-table" },
    var.tags
  )
}

resource "aws_route_table_association" "web" {
  count = 2

  subnet_id      = element(aws_subnet.web[*].id, count.index)
  route_table_id = element(aws_route_table.web[*].id, count.index)
}

resource "aws_route" "web_nat_gateway" {
  count = 2

  route_table_id         = element(aws_route_table.web[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)
}

################################################################################
# Private-LB Subnets
################################################################################

resource "aws_subnet" "private_lb" {
  count = 2

  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.private_lb_subnet_cidr, count.index)

  tags = merge(
    { "Name" = "${var.name}-${element(var.azs, count.index)}-private-lb-subnet" },
    var.tags
  )
}

################################################################################
# WAS Subnets
################################################################################

resource "aws_subnet" "was" {
  count = 2

  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.was_subnet_cidr, count.index)

  tags = merge(
    { "Name" = "${var.name}-${element(var.azs, count.index)}-was-subnet" },
    var.tags
  )
}

resource "aws_route_table_association" "was" {
  count = 2

  subnet_id      = element(aws_subnet.was[*].id, count.index)
  route_table_id = element(aws_route_table.web[*].id, count.index)
}

################################################################################
# DB Subnets
################################################################################

resource "aws_subnet" "db" {
  count = 2

  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.db_subnet_cidr, count.index)

  tags = merge(
    { "Name" = "${var.name}-${element(var.azs, count.index)}-db-subnet" },
    var.tags
  )
}

resource "aws_route_table_association" "db" {
  count = 2

  subnet_id      = element(aws_subnet.db[*].id, count.index)
  route_table_id = element(aws_route_table.web[*].id, count.index)
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { "Name" = "${var.name}-igw" },
    var.tags
  )
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "nat" {
  count = 2

  domain = "vpc"
  tags = merge(
    { "Name" = "${var.name}-${element(var.azs, count.index)}-eip" },
    var.tags
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = 2

  allocation_id = element(aws_eip.nat[*].id, count.index)
  subnet_id     = element(aws_subnet.public[*].id, count.index)
  tags = merge(
    { "Name" = "${var.name}-${element(var.azs, count.index)}-nat-gateway" },
    var.tags
  )

  depends_on = [aws_internet_gateway.this]
}