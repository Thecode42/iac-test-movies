output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
output "subnet_apps_id" {
  description = "ID de la subnet de Container Apps (para NAT Gateway)"
  value       = azurerm_subnet.snet_apps.id
}
output "subnet_private_id" {
  value = azurerm_subnet.snet_private.id
}