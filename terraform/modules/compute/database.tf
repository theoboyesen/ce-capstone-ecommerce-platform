data "aws_secretsmanager_secret" "db_password" {
  name = "capstone/db-password"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

locals {
  db_password = jsondecode(
    data.aws_secretsmanager_secret_version.db_password.secret_string
  )["password"]
}

resource "aws_db_subnet_group" "main" {
  name       = "capstone-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "capstone-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier              = "capstone-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  username = "admin"
  password = local.db_password

  # lifecycle {
  # prevent_destroy = true
# }    (Removed destroy protection as there is no data in the DB. It's a simulation for the project)

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  skip_final_snapshot = false
  final_snapshot_identifier = "capstone-db-final-snapshot"

  tags = {
    Project     = "capstone"
    Environment = "dev"
  }
}