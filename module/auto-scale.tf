resource "aws_autoscaling_group" "asg" {
  name                      = "asg"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.private-a.id, aws_subnet.private-b.id]
  launch_template {
    id = aws_launch_template.launch-t.id
    version = "$Latest"
  }      
  target_group_arns = ["${aws_lb_target_group.target.arn}"]

}
 
# resource "aws_autoscaling_policy" "asg-policy" {
#   name                   = "asg-policy"
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   policy_type            = "TargetTrackingScaling"
#   autoscaling_group_name = aws_autoscaling_group.asg.name
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#   target_value = 70
#   }
  
# }




