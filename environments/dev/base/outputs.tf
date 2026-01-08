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

output "waf_policy_id" {
  description = "ID de la WAF Policy"
  value       = module.app_gateway.waf_policy_id
}
