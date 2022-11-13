resource "aws_db_instance" "db" {
  allocated_storage      = 10
  name                   = "data"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "admin"
  password               = random_password.database_password.result
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false

  deletion_protection = false
  multi_az            = true

}