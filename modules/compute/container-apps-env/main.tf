/* ============================================================================
CONTAINER APP ENVIRONMENT - Azure Container Apps Environment (ACA Env)
 *   una subnet de infraestructura
============================================================================
* Proposito:
 * Crear un Azure Container Apps Environment (ACA Env) integrado a una VNet mediante
 *   una subnet de infraestructura, para alojar Container Apps (frontend/backend) con
 *   conectividad privada y control de red.
*
Autor: Roger Alcivar
============================================================================
*/

# Azure Container Apps Environment integrado a VNet .
resource "azurerm_container_app_environment" "aca_env" {
  name                       = "aca-env-${var.environment}-${var.location}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  infrastructure_subnet_id = var.subnet_apps_id

  tags = merge(var.tags, {
    "module" = "container-apps-env"
  })
}