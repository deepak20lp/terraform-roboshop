resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.common_tags.Component}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_ids.value)


  tags = var.common_tags
}

# resource "aws_lb_listener" "default_listener" {
#   load_balancer_arn = aws_lb.web_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"  # Common default policy
#   certificate_arn   = "arn:aws:acm:us-east-1:039612862266:certificate/7315c903-9f89-45df-9006-f230a893ece0"

# #this will add one listiner on port no 80 and one default rule
#   default_action {
#      type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "this is Fixed response from app_alb"
#       status_code  = "200"
#     }
#   }
# }

resource "aws_acm_certificate" "deepakreddy" {
  domain_name       = "deepakreddy.online"
  validation_method = "DNS"

  tags = var.common_tags
}

# data "aws_route53_zone" "example" {
#   name         = "example.com"
#   private_zone = false
# }

data "aws_route53_zone" "deepakreddy" {
  name         = "deepakreddy.online"
  private_zone = false
}

resource "aws_route53_record" "deepakreddy" {
  for_each = {
    for dvo in aws_acm_certificate.deepakreddy.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.deepakreddy.zone_id
}

resource "aws_acm_certificate_validation" "deepakreddy" {
  certificate_arn         = aws_acm_certificate.deepakreddy.arn
  validation_record_fqdns = [for record in aws_route53_record.deepakreddy : record.fqdn]
}

# resource "aws_lb_listener" "example" {
#   # ... other configuration ...

#   certificate_arn = aws_acm_certificate_validation.example.certificate_arn
# }


resource "aws_lb_listener" "web_alb" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.deepakreddy.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This the Fixed response content form web alb"
      status_code  = "200"
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = "deepakreddy.online"

  records = [
    {
      name    = ""
      type    = "A"
      alias   = {
        name    = aws_lb.web_alb.dns_name
        zone_id = aws_lb.web_alb.zone_id
      }
    },
  ]
}