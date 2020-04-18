output "vpc_region" {
  value = var.vpc_region
}

output "vpc_id" {
  value = aws_vpc.datascience_gb_vpc.id
}

// output "az_subnet_ids" {
//   value = zipmap(
//     var.availability_zone,
//     coalescelist(aws_subnet.public.*.id, aws_subnet.private.*.id)
//   )
//   description = "Map of AZ names to subnet IDs"
// }
