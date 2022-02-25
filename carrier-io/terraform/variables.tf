variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "Rancher AWS region for S3 buckets"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.21.0.0/16"
  description = "Rancher cluster name (testing, scratch, performance)"
}

variable "subnet_prefix_extension" {
  type        = number
  default     = 4
  description = "CIDR block bits extension to calculate CIDR blocks of each subnetwork."
}

variable "zone_offset" {
  type        = number
  default     = 8
  description = "CIDR block bits extension offset to calculate Public subnets, avoiding collisions with Private subnets."
}

variable "root_domain" {
  type    = string
  default = "ci.folio.org"
}

variable "resource_name" {
  type        = string
  default     = "carrier-io"
  description = "Name for provision resource"
}

variable "instance_type" {
  type        = string
  default     = "m5.large"
  description = "Type of EC2 instance. NOTICE: Pay attention and try to use reserved instances type"
}

variable "root_volume_size" {
  type        = number
  default     = 100
  description = "In GB size of root EBS volume attached to EC2 instance"
}

variable "key_pair_name" {
  type        = string
  description = "Name of key pair for SSH access"
}

# Carrier IO userdata values
variable "redis_password" {
  type        = string
  description = "Password for carrier IO Redis service"
}
variable "influx_password" {
  type        = string
  description = "Password for carrier IO Influx service"
}
variable "influx_username" {
  type        = string
  default     = "influx"
  description = "Username for carrier IO Influx service"
}
variable "rabbit_password" {
  type        = string
  description = "Password for carrier IO Rabbit service"
}

variable "tags" {
  type = map(any)
  default = {
    Terraform = "true"
    Project   = "folio"
    Team      = "kitfox"
    Tool      = "carrier-io"
  }
  description = "Default tags"
}

