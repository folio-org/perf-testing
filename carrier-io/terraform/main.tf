module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.1"

  name                        = join("-", [var.resource_name, "ec2-instance"])
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnets.public.ids, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  user_data_base64 = base64encode(local.user_data)

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = var.root_volume_size
    }
  ]

  tags = var.tags
}

# Security group for carrier instance
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1"

  name        = join("-", [var.resource_name, "sg"])
  description = "Folio Carrier IO security group"
  vpc_id      = data.aws_vpc.this.id

  ingress_cidr_blocks = [var.ingress_cidr]
  ingress_rules = [
    "ssh-tcp", "http-80-tcp", "http-8080-tcp", "postgresql-tcp", "mongodb-27017-tcp", "vault-tcp", "redis-tcp",
    "minio-tcp", "loki-grafana", "rabbitmq-5672-tcp"
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8086
      to_port     = 8086
      protocol    = "tcp"
      description = "Influx"
      cidr_blocks = var.ingress_cidr
    },
  ]
  egress_rules = ["all-all"]

  tags = var.tags
}

locals {
  user_data = <<-EOT
  #!/bin/bash

  yum update -y
  yum install -y yum-utils device-mapper-persistent-data lvm2 vim git docker
  systemctl start docker
  systemctl enable docker
  curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  yum groupinstall "Development Tools" -y

  git clone https://github.com/carrier-io/centry.git -b beta-1.0 /opt/centry

  export CENTRY_HOME=/opt/centry
  export PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

  cd $CENTRY_HOME

  sed -i -e "s|\#DIRECT_IP=YOUR_IP_HERE|DIRECT_IP=$PRIVATE_IP|g" Makefile

  sed -i -e "s|DEV_IP=|DEV_IP=$PRIVATE_IP|g" .env
  sed -i "s|APP_HOST=.*|APP_HOST=http://${var.resource_name}.${var.root_domain}|g" .env
  sed -i "s|APP_DOMAIN=|APP_DOMAIN=${var.resource_name}.${var.root_domain}|g" .env
  sed -i "s|LOKI_HOST=.*|LOKI_HOST=http://${var.resource_name}.${var.root_domain}:3100/loki/api/v1/push|g" .env

  sed -i -e "s|CARRIER_PATH=\$PWD|CARRIER_PATH=$CENTRY_HOME|g" .env
  sed -i -e "s|VOLUMES_PATH=\$CARRIER_PATH/volumes|VOLUMES_PATH=$CENTRY_HOME/volumes|g" .env

  make up
  EOT
}

resource "aws_route53_record" "ec2" {

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = join(".", [var.resource_name, var.root_domain])
  type    = "A"
  ttl     = "300"
  records = [module.ec2_instance.public_ip]
}
