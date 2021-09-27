resource "aws_db_instance" "lesson7-db" {
  allocated_storage    = 20
  max_allocated_storage = 30
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t2.micro"
  name                 = "lesson7_db"
  username             = "db_user"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.lesson7-mysql.id]
  db_subnet_group_name = aws_db_subnet_group.lesson7-db-sg.id

  tags = {
    Name = "lesson7-db"
  }
}