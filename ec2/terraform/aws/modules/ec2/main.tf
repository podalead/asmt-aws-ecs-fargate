resource "aws_subnet" "private_subnet_rds" {
  count = length(var.subnet_cidr)
  cidr_block = var.subnet_cidr[count.index].cidr
  availability_zone = format("%s%s", var.availability_zone, var.subnet_cidr[count.index].zone)
  vpc_id = var.vpc_id
  map_public_ip_on_launch = false
}

resource "aws_db_parameter_group" "parameters" {
  name_prefix = var.name_prefix
  description = "Database parameter group for ${var.identifier}"
  family = var.family

  tags = merge(var.tags, map("Name", format("%s", var.identifier)))

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name_prefix = var.name_prefix
  description = "Database subnet group for ${var.identifier}"
  subnet_ids = aws_subnet.private_subnet_rds.*.id

  tags = merge(var.tags, map("Name", format("%s", var.identifier)))
}

resource "aws_db_instance" "db_instance" {
  identifier = var.identifier

  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type = var.storage_type

  name = var.name
  username = var.username
  password = var.password
  port = var.port

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name = aws_db_parameter_group.parameters.name

  availability_zone = format("%sa", var.availability_zone)

  backup_retention_period = var.backup_retention_period
  backup_window = var.backup_window

  tags = merge(var.tags, map("Name", format("%s", var.identifier)))
}
