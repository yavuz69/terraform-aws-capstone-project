locals {
  secgr-dynamic-ports = [80,443]
  user = "aws_capstone"
  vpc_id = aws_vpc.capstone-v.id
}
  
              ### ALB SECURİRY GRUP ###
     
resource "aws_security_group" "alb" {
  name        = "${local.user}_ALB_Sec_Group"
  description = "ALB Security Group allows traffic HTTP and HTTPS ports from"
  vpc_id      = local.vpc_id


  dynamic "ingress" {
    for_each = local.secgr-dynamic-ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
    Name = "${local.user}_ALB_Sec_Group"
  }
}

         ### EC2 SECURİRY GRUP ###

resource "aws_security_group" "ec2" {
  name        = "${local.user}_EC2_Sec_Group"
  description = "EC2 Security Groups only allows traffic coming from"
  vpc_id      = local.vpc_id


  dynamic "ingress" {
    for_each = local.secgr-dynamic-ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      security_groups = [aws_security_group.alb.id]
  }
}
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.user}_EC2_Sec_Group"
  }
}

        ### RDS SECURİRY GRUP ###

resource "aws_security_group" "rds-seg" {
  name        = "${local.user}_RDS_Sec_Group"
  description = "allow ec2 sec"
  vpc_id      = local.vpc_id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.user}_RDS_Sec_Group"
  }
}
      
      ### NAT INSTANCE SECURİRY GRUP ###
       
resource "aws_security_group" "NAT-sec" {
  name        = "${local.user}_NAT_Sec_Group"
  description = "NAT-sec allows traffic HTTP & HTTPS & SSH ports from anywhere"
  vpc_id      = aws_vpc.capstone-v.id


  dynamic "ingress" {
    for_each = local.secgr-dynamic-ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
    Name = "${local.user}_NAT_Sec_Group"
  }
}


