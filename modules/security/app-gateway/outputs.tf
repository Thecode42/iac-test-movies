output "app_gateway_id" {
  description = "ID del Application Gateway"
  value       = azurerm_application_gateway.app_gateway.id
}
output "app_gateway_name" {
  description = "Nombre del Application Gateway"
  value       = azurerm_application_gateway.app_gateway.name
}
output "public_ip_address" {
  description = "IP pública del App Gateway (URL para acceder a Frontend)"
  value       = azurerm_public_ip.app_gateway_pip.ip_address
}
output "public_ip_id" {
  description = "ID de la Public IP"
  value       = azurerm_public_ip.app_gateway_pip.id
}
output "waf_policy_id" {
  description = "ID de la WAF Policy"
  value       = azurerm_web_application_firewall_policy.waf_policy.id
}
output "app_gateway_subnet_id" {
  description = "ID de la subnet del App Gateway"
  value       = azurerm_subnet.subnet_app_gateway.id
}
output "nsg_app_gateway_id" {
  description = "ID del NSG del App Gateway"
  value       = azurerm_network_security_group.nsg_app_gateway.id
}
