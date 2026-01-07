resource "azurerm_resource_group" "rg_dev" {
  name     = "rg-movieapp-${var.environment}-${var.location}"
  location = var.location
  tags = {
    environment = var.environment
    project     = "movieapp"
  }
  
}

module "networking" {
  source              = "../../../modules/networking"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = azurerm_resource_group.rg_dev.location
  
  vnet_name           = "vnet-movieapp-${var.environment}-${var.location}"
  vnet_address_space  = ["10.0.0.0/16"]
  # Direcciones IP para el Container Apps
  subnet_apps_prefix    = "10.0.0.0/23"
  # Direcciones IP para endpoints privados para recursos persistentes (ACR, Key Vault)
  subnet_private_prefix = "10.0.2.0/24"
  tags = azurerm_resource_group.rg_dev.tags
}