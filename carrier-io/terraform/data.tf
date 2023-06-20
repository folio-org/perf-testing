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
    "${var.subnet_type_tag_key}" : "${var.subnet_type_tag_value}"
  }
}

# Get AWS cerificate
data "aws_acm_certificate" "amazon_issued" {
  domain = "*.${var.root_domain}"
  types  = ["AMAZON_ISSUED"]
}

# Get data about root domain
data "aws_route53_zone" "domain" {
  name = var.root_domain
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}