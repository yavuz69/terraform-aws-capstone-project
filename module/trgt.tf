resource "aws_lb_target_group" "target" {
  name     = "target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.capstone-v.id
}


# resource "aws_lb_target_group_attachment" "test" {
#   target_group_arn = aws_lb_target_group.target.arn
#   target_id        = aws_lb.alb-capstone.id
#   port             = 80
# }