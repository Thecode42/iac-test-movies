/* ============================================================================
INFRAESTRUCTURA PRINCIPAL
============================================================================
* Proposito:
*   Desplegar la infraestructura base y los componentes principales de la solución:
 *   - Resource Group
 *   - Networking (VNet + subnets)
 *   - Egress (NAT Gateway)
 *   - Azure Container Apps Environment
 *   - Container Apps: frontend (publico) y backend (interno)
*
Autor: Roger Alcivar
============================================================================
 */

# Resource group principal
resource "azurerm_resource_group" "rg_dev" {
  name     = "rg-moviesapp-${var.environment}-${var.location}"
  location = var.location
  tags = {
    environment = var.environment
    project     = "moviesapp"
  }
}
# VNet + subnets (apps/ACA env/private endpoints) y outputs
module "networking" {
  source              = "../../../modules/networking"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = azurerm_resource_group.rg_dev.location

  vnet_name          = "vnet-moviesapp-${var.environment}-${var.location}"
  vnet_address_space = ["10.0.0.0/16"]
  # CIDR para subnet de workloads/segmentación adicional
  subnet_apps_prefix = "10.0.6.0/23"
  # CIDR para la subnet de infraestructura del Azure Container Apps Environment
  subnet_aca_env_prefix = "10.0.2.0/23"
  # Direcciones IP para endpoints privados para recursos persistentes (ACR, Key Vault)
  subnet_private_prefix = "10.0.4.0/24"
  tags                  = azurerm_resource_group.rg_dev.tags
}
# NAT Gateway para IP de salida estable desde la subnet
module "nat_gateway" {
  source = "../../../modules/networking/nat-gateway"

  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = azurerm_resource_group.rg_dev.location
  environment         = var.environment
  tags                = azurerm_resource_group.rg_dev.tags

  vnet_name         = module.networking.vnet_name
  subnet_apps_id    = module.networking.subnet_apps_id
  subnet_nat_prefix = "10.0.5.0/24"

  depends_on = [module.networking]
}
# ACA Env integrado a VNet usando la subnet de infraestructura
module "container_apps_env" {
  source = "../../../modules/compute/container-apps-env"

  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = azurerm_resource_group.rg_dev.location
  environment         = var.environment
  tags                = azurerm_resource_group.rg_dev.tags

  subnet_apps_id = module.networking.subnet_aca_env_id

  depends_on = [module.networking]
}

# Frontend Container App (Angular) - ingress externo
module "container_app_frontend" {
  source = "../../../modules/compute/container-app"

  resource_group_name          = azurerm_resource_group.rg_dev.name
  container_app_environment_id = module.container_apps_env.container_app_environment_id
  container_app_name           = "app-frontend-${var.environment}-${var.location}"
  container_image              = var.frontend_image
  cpu                          = "0.25"
  memory                       = "0.5Gi"
  container_port               = 80
  min_replicas                 = 0
  max_replicas                 = 1
  expose_publicly              = true
  app_type                     = "frontend"
  tags                         = azurerm_resource_group.rg_dev.tags
  environment_variables        = {}

  depends_on = [module.container_apps_env]
}

# Backend Container App (.NET 7.0) - solo interno
module "container_app_backend" {
  source = "../../../modules/compute/container-app"

  resource_group_name          = azurerm_resource_group.rg_dev.name
  container_app_environment_id = module.container_apps_env.container_app_environment_id
  container_app_name           = "app-backend-${var.environment}"
  container_image              = var.backend_image
  cpu                          = "0.5"
  memory                       = "1Gi"
  container_port               = 8080
  min_replicas                 = 1
  max_replicas                 = 1
  expose_publicly              = false
  app_type                     = "backend"
  tags                         = azurerm_resource_group.rg_dev.tags
  environment_variables        = var.backend_environment_variables

  depends_on = [module.container_apps_env]
}