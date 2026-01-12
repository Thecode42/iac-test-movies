output "subnet_apps_id" {
  description = "Application workload subnet ID"
  value       = module.networking.subnet_apps_id
}
output "nat_gateway_public_ip" {
  description = "IP publica usada como egress fijo para workloads en la subnet asociada al NAT Gateway."
  value       = module.nat_gateway.nat_public_ip_address
}
output "nat_gateway_id" {
  description = "ID del NAT Gateway"
  value       = module.nat_gateway.nat_gateway_id
}
output "frontend_fqdn" {
  description = "FQDN publica del Frontend"
  value       = "https://${module.container_app_frontend.fqdn}"
}
output "container_apps_environment_id" {
  description = "ID del Container Apps Environment"
  value       = module.container_apps_env.container_app_environment_id
}