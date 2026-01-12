output "container_app_environment_id" {
  description = "ID del Container Apps Environment"
  value       = azurerm_container_app_environment.aca_env.id
}

output "container_app_environment_name" {
  description = "Nombre del Container Apps Environment"
  value       = azurerm_container_app_environment.aca_env.name
}

output "default_domain" {
  description = "Dominio por defecto del Environment"
  value       = azurerm_container_app_environment.aca_env.default_domain
}