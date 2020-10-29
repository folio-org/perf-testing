locals {
  # If not using default vpc in region, use vpc_id passed in
  vpc_id      = data.aws_vpc.default.id
  subnet_ids  = data.aws_subnet_ids.available.ids
}
