output "carrier_io_address" {
  value       = aws_instance.carrier-io.public_dns
  description = "IP address of Carrier.IO instance"
}
