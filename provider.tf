provider "aws" {
  region     = var.aws_region
}

provider "postgresql" {
  host            = module.db_instance.rds_endpoint
  port            = 5432
  username        = var.username
  password        = var.password # Overweeg het gebruik van een Terraform-variabele of geheim voor dit wachtwoord
  superuser       = false
  sslmode         = "require"
  connect_timeout = 15
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
    }
  }
}

# variable "postgresql_password" {
#   description = "Het wachtwoord voor de PostgreSQL-database"
#   # Gebruik bijvoorbeeld sensitive = true om dit wachtwoord te verbergen in logs.
#   sensitive = true 
#   # Je kunt ook een standaardwaarde toevoegen of het buiten deze definitie houden om het bij het toepassen te moeten specificeren:
#   # default = "jouwwachtwoord"
# }
