variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "m5.2xlarge"
}

variable "use_default_vpc" {
  type        = bool
  default     = true
  description = "Should the default VPC for the region selected be used for Carrier.IO"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "If use_default_vpc is false, the vpc id that Carrier.IO should use"
}

variable "ingressCIDRblock" {
  type    = list
  default = ["0.0.0.0/0"]
}

variable "creds_output_path" {
  description = "Where to save the id_rsa config file. Should end in a forward slash `/` ."
  type        = string
  default     = "./"
}

variable "redis_password" {
  type        = string
  description = "Password for Redis"
}

variable "rabbit_password" {
  type        = string
  description = "Password for Rabbit"
}

variable "influx_password" {
  type        = string
  description = "Password for Influx"
}
