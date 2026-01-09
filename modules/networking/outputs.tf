output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
output "subnet_private_id" {
  value = azurerm_subnet.snet_private.id
}
output "subnet_aca_env_id" {
  description = "Container Apps Environment subnet ID (without delegation)"
  value       = azurerm_subnet.snet_aca_env.id
}
output "subnet_apps_id" {
  description = "Container Apps subnet ID (delegated)"
  value       = azurerm_subnet.snet_apps.id
}