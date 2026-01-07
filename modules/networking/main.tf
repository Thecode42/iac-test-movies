# VNet Principal del proyecto
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Subnet para Container Apps Environment
# NOTA : Container Apps se le asigna una subnet delegada a Microsoft.App/environments para la gestion automatica.
resource "azurerm_subnet" "snet_apps" {
  name                 = "snet-container-apps"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_apps_prefix]

  delegation {
    name = "aca-delegation"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Subnet para Private Endpoints en la Zona de Data and Secrets (ACR y Key Vault)
resource "azurerm_subnet" "snet_private" {
  name                 = "snet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_private_prefix]
  private_endpoint_network_policies = "Disabled"
}

# Network Security Group el Firewall Basico para la Subnet de Apps
resource "azurerm_network_security_group" "nsg_apps" {
  name                = "nsg-container-apps"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Permitir trafico HTTPS interno
  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*" # En Prod, restringir a la subnet de Front Door
    destination_address_prefix = "*"
  }
}

# Asociación del NSG a la Subnet de Apps
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_apps" {
  subnet_id                 = azurerm_subnet.snet_apps.id
  network_security_group_id = azurerm_network_security_group.nsg_apps.id
}
