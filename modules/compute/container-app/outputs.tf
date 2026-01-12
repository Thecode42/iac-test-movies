output "container_app_id" {
  description = "ID del Container App"
  value       = azurerm_container_app.app.id
}
output "container_app_name" {
  description = "Nombre del Container App"
  value       = azurerm_container_app.app.name
}
output "latest_revision_name" {
  description = "Nombre de la ultima version desplegada"
  value       = azurerm_container_app.app.latest_revision_name
}
output "fqdn" {
  description = "FQDN del Container AppRetorna FQDN si expose_publicly=true, si no internal-only"
  value       = try(azurerm_container_app.app.ingress[0].fqdn, "internal-only")
}