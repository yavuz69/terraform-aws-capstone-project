resource "aws_lb" "alb-capstone" {
  name               = "alb-capstone"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = ["${aws_subnet.public-a.id}" ,"${aws_subnet.public-b.id}"]
  tags = {
    Environment = "awscapstoneALB"
  }

}

