# Container Apps Environment (sin Log Analytics)
resource "azurerm_container_app_environment" "aca_env" {
  name                       = "aca-env-${var.environment}-${var.location}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  infrastructure_subnet_id = var.subnet_apps_id

  tags = merge(var.tags, {
    "module" = "container-apps-env"
  })
}
