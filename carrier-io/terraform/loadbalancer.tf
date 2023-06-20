# Attention!!! For current moment carrier natively not support load balancing
# Create Application Load Balancer with target group
module "alb" {
  count      = var.deploy_load_balancer ? 1 : 0
  depends_on = [module.security_group]

  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.7"

  name = join("-", [var.resource_name, "alb"])

  load_balancer_type = "application"

  vpc_id          = data.aws_vpc.this.id
  subnets         = [element(data.aws_subnets.public.ids, 0), element(data.aws_subnets.public.ids, 1)]
  security_groups = ["sg-a150ded5"]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        carrier-io = {
          target_id = module.ec2_instance.id
          port      = 80
        }
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.amazon_issued.arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  tags = var.tags
}

# Create CNAME record in DNS zone for carrier instance
resource "aws_route53_record" "www" {
  count      = var.deploy_load_balancer ? 1 : 0
  depends_on = [module.alb]

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = join(".", [var.resource_name, var.root_domain])
  type    = "CNAME"
  ttl     = "300"
  records = [module.alb[0].lb_dns_name]
}
