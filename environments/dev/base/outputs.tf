output "subnet_apps_id" {
  value = module.networking.subnet_apps_id
}
output "app_gateway_public_ip" {
  description = "IP publica del App Gateway"
  value       = module.app_gateway.public_ip_address
}
output "app_gateway_id" {
  description = "ID del App Gateway"
  value       = module.app_gateway.app_gateway_id
}
output "nat_gateway_public_ip" {
  description = "IP publica del NAT Gateway (egress del Backend)"
  value       = module.nat_gateway.nat_public_ip_address
}
output "nat_gateway_id" {
  description = "ID del NAT Gateway"
  value       = module.nat_gateway.nat_gateway_id
}
