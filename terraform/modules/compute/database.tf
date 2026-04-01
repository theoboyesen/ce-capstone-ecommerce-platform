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
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  skip_final_snapshot = true

  tags = {
    Project     = "capstone"
    Environment = "dev"
  }
}