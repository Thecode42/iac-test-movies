output "vnet_id" {
    description = "ID de la VNet creada"
  value = azurerm_virtual_network.vnet.id
}
output "vnet_name" {
    description = "Nombre de la VNet creada"
  value = azurerm_virtual_network.vnet.name
}
output "subnet_private_id" {
    description = "Private Endpoints subnet ID"
  value = azurerm_subnet.snet_private.id
}
output "subnet_aca_env_id" {
  description = "Container Apps Environment infrastructure subnet ID (delegated to Microsoft.App/environments)"
  value       = azurerm_subnet.snet_aca_env.id
}
output "subnet_apps_id" {
  description = "Application workload subnet ID"
  value       = azurerm_subnet.snet_apps.id
}
output "subnet_aca_env_cidr" {
    description = "CIDR prefix of the Container Apps Environment infrastructure subnet"
  value = var.subnet_aca_env_prefix
}