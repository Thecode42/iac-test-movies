output "subnet_apps_id" {
  value = module.networking.subnet_apps_id
}
/* output "app_gateway_public_ip" {
  description = "IP publica del App Gateway"
  value       = module.app_gateway.public_ip_address
}
output "app_gateway_id" {
  description = "ID del App Gateway"
  value       = module.app_gateway.app_gateway_id
} */
output "nat_gateway_public_ip" {
  description = "IP publica del NAT Gateway (egress del Backend)"
  value       = module.nat_gateway.nat_public_ip_address
}
output "nat_gateway_id" {
  description = "ID del NAT Gateway"
  value       = module.nat_gateway.nat_gateway_id
}
output "frontend_url" {
  description = "URL pública del Frontend"
  value       = module.container_app_frontend.fqdn
}

# output "backend_fqdn" {
#   description = "FQDN interno del Backend (para Frontend)"
#   value       = "http://${module.container_app_backend.container_app_name}:8080"
# }

output "container_apps_environment_id" {
  description = "ID del Container Apps Environment"
  value       = module.container_apps_env.container_app_environment_id
}
