# Get VPC network folio-rancher-vpc
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Get public subnet
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    Type : "public"
  }
}

# Get data about root domain
data "aws_route53_zone" "domain" {
  name = var.root_domain
}

# Get AWS cerificate
data "aws_acm_certificate" "amazon_issued" {
  domain      = "*.${var.root_domain}"
  types       = ["AMAZON_ISSUED"]
}

# Create Application Load Balancer with target group
module "alb" {
  count = var.deploy_load_balancer ? 1 : 0
  depends_on = [module.security_group]

  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = join("-", [var.resource_name, "alb"])

  load_balancer_type = "application"

  vpc_id             = data.aws_vpc.this.id
  subnets            = [element(data.aws_subnets.public.ids, 0), element(data.aws_subnets.public.ids, 1)]
  security_groups    = [module.security_group[0].security_group_id]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        carrier-io = {
          target_id = module.ec2_instance.id
          port = 80
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
      port               = 80
      protocol           = "HTTP"
      action_type        = "redirect"
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
  count = var.deploy_load_balancer ? 1 : 0
  depends_on = [module.alb]

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = join(".", [var.resource_name, var.root_domain])
  type    = "CNAME"
  ttl     = "300"
  records = [module.alb[0].lb_dns_name]
}

# Security group for carrier instance
module "security_group" {
  count = var.deploy_load_balancer ? 1 : 0
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.8.0"

  name        = join("-", [var.resource_name, "sg"])
  description = "Folio Carrier IO security group"
  vpc_id      = data.aws_vpc.this.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "redis-tcp", "rabbitmq-5672-tcp", "rabbitmq-15672-tcp", "https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8086
      to_port     = 8086
      protocol    = "tcp"
      description = "Influx"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3100
      to_port     = 3100
      protocol    = "tcp"
      description = "Loki"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_rules = ["all-all"]

  tags = var.tags
}
