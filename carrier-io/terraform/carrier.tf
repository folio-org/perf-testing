resource "aws_security_group" "Carrier_security_group" {
  name         = "Carrier.IO security group"
  description  = "Carrier.IO security group"
  vpc_id       = local.vpc_id

  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "carrier-io" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.instance_type
  key_name                = aws_key_pair.ssh.id

  vpc_security_group_ids      = [aws_security_group.Carrier_security_group.id]
  subnet_id                   = element(tolist(local.subnet_ids), 0)
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "500"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_dns
      user        = "ubuntu"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu --private-key ${local_file.private_key.filename} -i '${self.public_dns},' ${path.module}/files/carrierbook.yml --extra-vars 'APP_HOST=${self.public_dns} CARRIER_PATH=/opt MASTER_PASSWORD=${var.carrier_master_password}' --ssh-common-args='-o StrictHostKeyChecking=no'"
  }

  tags = {
    Name     = "carrier-io"
  }

}
