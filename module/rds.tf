resource "aws_db_instance" "capstone_rds" {
  allocated_storage           = 20 # GB of storage dedicated to the database
  engine                      = "mysql"
  engine_version              = "8.0.28"
  identifier                  = "aws-capstone-rds"
  instance_class              = "db.t3.micro"
  db_name                     = var.dataname
  multi_az                    =  false
  username                    = "admin"
  password                    = "Clarusway1234"
  skip_final_snapshot         = true # Don't take a final snapshot 
  port                        = 3306
  vpc_security_group_ids      = [aws_security_group.rds-seg.id]
  db_subnet_group_name        = aws_db_subnet_group.rdssubnet.name
}

resource "aws_db_subnet_group" "rdssubnet" {
  name       = "main"
  description  = "aws capstone RDS Subnet Group"
  subnet_ids = ["${aws_subnet.private-a.id}", "${aws_subnet.private-b.id}"]

  tags = {
    Name = "${local.user}_RDS_Subnet_Group"
  }
}

