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
}

# Asociación del NSG a la Subnet de Apps
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_apps" {
  subnet_id                 = azurerm_subnet.snet_apps.id
  network_security_group_id = azurerm_network_security_group.nsg_apps.id
}
# REGLAS:
# BLOQUEAR Backend desde Internet
resource "azurerm_network_security_rule" "deny_backend_from_internet" {
  name                        = "DenyBackendFromInternet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = var.backend_internal_ports
  source_address_prefix       = "Internet"
  destination_address_prefix  = var.subnet_apps_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_apps.name
}
# Permitir HTTPS desde Internet (Frontend)
resource "azurerm_network_security_rule" "allow_https_inbound" {
  name                        = "AllowHTTPSInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = var.subnet_apps_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_apps.name
}
# Permitir Frontend a Backend (comunicación interna)
resource "azurerm_network_security_rule" "allow_frontend_to_backend" {
  name                        = "AllowFrontendToBackend"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = var.backend_internal_ports
  source_address_prefix       = var.subnet_apps_prefix
  destination_address_prefix  = var.subnet_apps_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_apps.name
}

# Permitir Backend a APIs Externas
resource "azurerm_network_security_rule" "allow_backend_egress_http" {
  name                        = "AllowBackendEgressHTTP"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.subnet_apps_prefix
  destination_address_prefix  = "Internet"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_apps.name
}

# Permitir Backend a APIs Externas (HTTPS)
resource "azurerm_network_security_rule" "allow_backend_egress_https" {
  name                        = "AllowBackendEgressHTTPS"
  priority                    = 210
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.subnet_apps_prefix
  destination_address_prefix  = "Internet"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_apps.name
}

# Permitir Backend a DNS
resource "azurerm_network_security_rule" "allow_backend_egress_dns" {
  name                        = "AllowBackendEgressDNS"
  priority                    = 220
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = var.subnet_apps_prefix
  destination_address_prefix  = "Internet"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_apps.name
}

# Permitir Backend a Azure Services (Log Analytics, App Insights, etc)
resource "azurerm_network_security_rule" "allow_backend_to_azure_services" {
  name                        = "AllowBackendToAzureServices"
  priority                    = 230
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.subnet_apps_prefix
  destination_address_prefix  = "AzureCloud"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_apps.name
}

# DENY DEFAULT - Bloquear todo trafico Inbound no autorizado
resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_apps.name
}