output "tgw_attachment_id" {
  description = "TGW attachment ID"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "routeable_subnets" {
  description = "List of Rouetable Subnets"
  value       = [for _az, subnet in aws_subnet.routeable : subnet.id]
}
