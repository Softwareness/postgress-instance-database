

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["subnet-fb7f12a0", "subnet-f0311bb9"] # Vervang door je eigen subnet-IDs

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_security_group" "allow_postgresql" {
  name        = "allow_postgresql"
  description = "Allow PostgreSQL inbound traffic"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Pas dit aan om veiligheidsredenen
  }
}

resource "aws_db_parameter_group" "example" {
  name   = "example-parametergroup"
  family = "postgres15"

  parameter {
    name  = "client_encoding"
    value = "utf8"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  # Voeg meer parameters toe zoals nodig

  tags = {
    Name = "example-parametergroup"
  }
}

module "db_instance" {
  source = "./modules/db_instance"
    allocated_storage    = var.allocated_storage
    storage_type         = var.storage_type
    engine               = var.engine
    engine_version       = var.engine_version
    instance_class       = var.instance_class
    username             = var.username
    password             = var.password # Verander dit naar een sterk wachtwoord
    parameter_group_name = aws_db_parameter_group.example.name
    vpc_security_group_ids = aws_security_group.allow_postgresql.id
    db_subnet_group_name = aws_db_subnet_group.default.id
}


################################################################################
# DB Database
################################################################################
module "db_database" {
  source = "./modules/db_database"
    name                    = var.name
    owner                   = var.owner
    tablespace_name         = var.tablespace_name
    connection_limit        = var.connection_limit 
    allow_connections       = var.allow_connections
    is_template             = var.is_template
    template                = var.template
    encoding                = var.encoding
    lc_collate              = var.lc_collate
    lc_ctype                = var.lc_ctype
    host                    = split(":", module.db_instance.rds_endpoint)[0]

    # depends_on = [ module.db_instance ]
}


# resource "postgresql_database" "mydb" {
#   name  = "my_new_database"
#   owner = "ferry"
# }
