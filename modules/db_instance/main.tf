resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
#   db_name              = "" # Leeg om geen specifieke database aan te maken
  username             = var.username
  password             = var.password # Verander dit naar een sterk wachtwoord
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true
  publicly_accessible  = true

  vpc_security_group_ids = [var.vpc_security_group_ids]
  db_subnet_group_name   = var.db_subnet_group_name

  tags = {
    Name = "My PostgreSQL RDS instance"
  }
}