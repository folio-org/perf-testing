module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.4.0"

  name                        = join("-", [var.resource_name, "ec2-instance"])
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
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

locals {
  user_data = <<-EOT
  #!/bin/bash
  apt update
  apt install -y apt-transport-https wget gnupg git vim
  apt-add-repository ppa:ansible/ansible
  apt update
  apt install -y ansible
  cd /tmp
  git clone https://github.com/carrier-io/installer.git --branch v.2.5

  sed -i "s#localhost#${var.resource_name}.${var.root_domain}#g" /tmp/installer/vars/default.yml
  sed -i "s#REDIS_PASSWORD: password#REDIS_PASSWORD: ${var.redis_password}#g" /tmp/installer/vars/default.yml
  sed -i "s#INFLUX_PASSWORD: password#INFLUX_PASSWORD: ${var.influx_password}#g" /tmp/installer/vars/default.yml
  sed -i "s#INFLUX_USERNAME: admin#INFLUX_USERNAME: ${var.influx_username}#g" /tmp/installer/vars/default.yml
  sed -i "s#RABBIT_PASSWORD: password#RABBIT_PASSWORD: ${var.rabbit_password}#g" /tmp/installer/vars/default.yml
  echo -e "[myhost]\nlocalhost ansible_connection=local" > /tmp/installer/host

  cd ~
  ansible-playbook /tmp/installer/carrierbook.yml -i /tmp/installer/host
  docker stop carrier_jenkins_1
  docker rm carrier_jenkins_1
  docker rmi jenkins/jenkins:lts
  EOT
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/*/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}