module "rds" {
  source = "./modules/rds"

  availability_zone = var.availability_zones
  vpc_security_group_ids = [ aws_security_group.rds.id, aws_security_group.egress.id ]
  vpc_id = module.vpc.vpc_id

  engine = "postgres"
  storage_type = "standard"
  engine_version = "11.5"
  instance_class = "db.t2.micro"
  allocated_storage = 20
  storage_encrypted = false
  subnet_ids = module.vpc.database_subnets

  backup_retention_period = 0
  backup_window = "03:00-06:00"
  family = "postgres11"
  identifier = "fsdfgsd"
  name = "relacto"
  name_prefix = "alocal-db-group"

  parameters = []
  username = "macho"
  password = "testMatho_1"
  port = "5432"

  tags = {
    Name = "gate"
    Environment = "test"
  }
}