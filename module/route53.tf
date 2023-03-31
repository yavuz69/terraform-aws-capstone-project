data "aws_route53_zone" "capstone" {
  name         = var.host_zone_name
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.capstone.zone_id
  name    = var.recordname
  type    = "A"
  alias {
    name                   = aws_lb.alb-capstone.dns_name
    zone_id                = aws_lb.alb-capstone.zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "www1" {
#   zone_id = data.aws_route53_zone.capstone.zone_id
#   name    = var.recordname
#   type    = "A"

#   failover_routing_policy {
#     type = "PRIMARY"
#   }

#   set_identifier = "www1"
#   alias {
#     name                   = aws_lb.alb-capstone.dns_name
#     zone_id                = aws_lb.alb-capstone.zone_id
#     evaluate_target_health = true
#   }
# }
# resource "aws_route53_record" "www2" {
#   zone_id = data.aws_route53_zone.capstone.zone_id
#   name    = var.recordname
#   type    = "A"
#   #ttl     = "5"

#   failover_routing_policy {
#     type = "SECONDARY"
#   }

#   set_identifier = "www2"
#   #records        = ["${aws_elb.web.dns_name}"]
#   alias {
#     name                   = aws_s3_bucket.capstone-failover.bucket
#     zone_id                = "Z3AQBSTGFYJSTF"
#     evaluate_target_health = true
  
#   }
# }