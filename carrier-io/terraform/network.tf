# Get all available AZs in our region
data "aws_availability_zones" "available_azs" {
  state = "available"
}

# Get data about root domain
data "aws_route53_zone" "domain" {
  name = var.root_domain
}

# Reserve Elastic IP to be used in our NAT gateway
resource "aws_eip" "nat_gw_elastic_ip" {
  vpc = true

  tags = {
    Name = join("-", [var.resource_name, "nat-eip"])
  }
}

# Create CNAME record in DNS zone for carrier instance
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = join(".", [var.resource_name, var.root_domain])
  type    = "CNAME"
  ttl     = "300"
  records = [module.ec2_instance.public_dns]
}

# Create VPC for carrier
/*module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.12.0"

  name = join("-", [var.resource_name, "vpc"])
  cidr = var.vpc_cidr_block
  azs  = data.aws_availability_zones.available_azs.names

  create_igw           = true
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  reuse_nat_ips        = true
  external_nat_ip_ids  = [aws_eip.nat_gw_elastic_ip.id]

  private_subnets = [
    # this loop will create a one-line list as ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20", ...] with a length depending on how many Zones are available
    for zone_id in data.aws_availability_zones.available_azs.zone_ids :
    cidrsubnet(var.vpc_cidr_block, var.subnet_prefix_extension, tonumber(substr(zone_id, length(zone_id) - 1, 1)) - 1)
  ]

  public_subnets = [
    # this loop will create a one-line list as ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20", ...] with a length depending on how many Zones are available
    # there is a zone Offset variable, to make sure no collisions are present with private subnet blocks
    for zone_id in data.aws_availability_zones.available_azs.zone_ids :
    cidrsubnet(var.vpc_cidr_block, var.subnet_prefix_extension, tonumber(substr(zone_id, length(zone_id) - 1, 1)) + var.zone_offset - 1)
  ]

  database_subnets = [
    for zone_id in data.aws_availability_zones.available_azs.zone_ids :
    cidrsubnet(var.vpc_cidr_block, var.subnet_prefix_extension, tonumber(substr(zone_id, length(zone_id) - 1, 1)) + (var.zone_offset / 2) - 1)
  ]

  tags = merge(
    {
      "kubernetes.io/cluster/folio-testing" = "shared"
    },
    var.tags
  )
  public_subnet_tags = {
    "kubernetes.io/cluster/folio-testing" = "shared"
    "kubernetes.io/role/elb"              = "1"
    Type                                  = "public"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/folio-testing" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
    Type                                  = "private"
  }
}
*/

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "selected" {}

# Security group for carrier instance
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.8.0"

  name        = join("-", [var.resource_name, "sg"])
  description = "Folio Carrier IO security group"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "redis-tcp", "rabbitmq-5672-tcp", "rabbitmq-15672-tcp"]
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
