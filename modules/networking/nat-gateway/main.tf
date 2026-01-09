# ============================================================================
# NAT GATEWAY - IP Publica Estática para Egress
# ============================================================================
# 
# Proposito: Proporcionar una IP publica FIJA para que el Backend acceda
# a APIs externas. Esto permite:
# - Whitelisting de IP en APIs externas
# - Logs/auditoría más claros
# - IP pública única conocida
#
# Arquitectura:
# Container Apps (Backend) → NAT Gateway → Internet (IP pública fija)
# ============================================================================

# Public IP para NAT Gateway
resource "azurerm_public_ip" "nat_gateway_pip" {
  name                = "pip-nat-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  idle_timeout_in_minutes = 4

  tags = merge(var.tags, {
    "module" = "nat-gateway"
  })
}

# Subnet dedicada para NAT Gateway (best practice)
resource "azurerm_subnet" "subnet_nat_gateway" {
  name                 = "snet-nat"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_nat_prefix]
}

# NAT Gateway - Egress Point para Backend
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "natgw-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  idle_timeout_in_minutes = 4

  tags = merge(var.tags, {
    "module" = "nat-gateway"
  })

  depends_on = [azurerm_public_ip.nat_gateway_pip]
}

# Asociar Public IP al NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_public_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip.id
}

# Asociar NAT Gateway a la subnet de Container Apps
# Todos los containers en esta subnet usaran el NAT Gateway para egress
resource "azurerm_subnet_nat_gateway_association" "nat_gateway_assoc" {
  subnet_id      = var.subnet_apps_id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id

  depends_on = [azurerm_nat_gateway.nat_gateway]
}

# NSG para subnet NAT Gateway (si se usa)
resource "azurerm_network_security_group" "nsg_nat_gateway" {
  name                = "nsg-nat"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    "module" = "nat-gateway"
  })
}

# Asociar NSG a subnet NAT Gateway
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_nat" {
  subnet_id              = azurerm_subnet.subnet_nat_gateway.id
  network_security_group_id = azurerm_network_security_group.nsg_nat_gateway.id
}