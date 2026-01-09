# Public IP para App Gateway
resource "azurerm_public_ip" "app_gateway_pip" {
  name                = "pip-appgw-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(var.tags, {
    "module" = "app-gateway"
  })
}

# Subnet para App Gateway (separada de Container Apps)
resource "azurerm_subnet" "subnet_app_gateway" {
  name                 = "snet-appgw"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_appgw_prefix]
}

# Application Gateway - Standard_WAFv2 SKU
resource "azurerm_application_gateway" "app_gateway" {
  name                = "appgw-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  # SKU: Standard_WAFv2 (incluye WAF)
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = var.app_gateway_capacity
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = var.waf_mode
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  # Gateway IP Configuration
  gateway_ip_configuration {
    name      = "appgw-ipconfig"
    subnet_id = azurerm_subnet.subnet_app_gateway.id
  }

  # Frontend Port Configuration - HTTP
  frontend_port {
    name = "feport-http"
    port = 80
  }

  # Frontend Port Configuration - HTTPS (future, para production)
  frontend_port {
    name = "feport-https"
    port = 443
  }
  # Frontend IP Configuration
  frontend_ip_configuration {
    name                 = "feipconfig"
    public_ip_address_id = azurerm_public_ip.app_gateway_pip.id
  }
  # HTTP Setting - Comunicacion con Backend
  backend_http_settings {
    name                  = "bhsettings"
    cookie_based_affinity = "Disabled"
    port                  = var.backend_port
    protocol              = "Http"
    request_timeout       = 20
  }
  # Backend Address Pool - Container Apps FQDN
  backend_address_pool {
    name  = "beap-container-apps"
    fqdns = [var.container_apps_fqdn]
  }
  # HTTP Listener
  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "feipconfig"
    frontend_port_name             = "feport-http"
    protocol                       = "Http"
  }
  # Request Routing Rule
  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "beap-container-apps"
    backend_http_settings_name = "bhsettings"
    priority                   = 1
  }
  /*
    # Activar cuando se tenga el container apps FQDN
  # Probe: Health check para Container Apps
  probe {
    name                = "health-probe"
    protocol            = "Http"
    path                = var.health_probe_path
    interval            = 30
    timeout             = 10
    unhealthy_threshold = 3
    port                = var.backend_port
    host                = var.container_apps_fqdn
    match {
      status_code = ["200-399"]
    }
  }
  # Reachability conditions (Terraform requirement)
  backend_http_settings {
    name                                = "bhsettings-probe"
    cookie_based_affinity               = "Disabled"
    port                                = var.backend_port
    protocol                            = "Http"
    request_timeout                     = 20
    probe_name                          = "health-probe"
    pick_host_name_from_backend_address = true
  }
   */
  tags = merge(var.tags, {
    "module" = "app-gateway"
    "waf"    = "enabled"
  })
  depends_on = [
    azurerm_subnet.subnet_app_gateway
  ]
  lifecycle {
    ignore_changes = [tags]
  }
}

# NSG para App Gateway Subnet
resource "azurerm_network_security_group" "nsg_app_gateway" {
  name                = "nsg-appgw"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Permitir tráfico HTTP desde Internet
  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Permitir trafico HTTPS desde Internet (future)
  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  # Permitir Azure Load Balancer health probes
  security_rule {
    name                       = "AllowAzureLoadBalancer"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
  # Permitir comunicacion entre App Gateway y Container Apps
  security_rule {
    name                       = "AllowAppGwToContainerApps"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.backend_port
    source_address_prefix      = var.subnet_appgw_prefix
    destination_address_prefix = var.container_apps_subnet_prefix
  }

  # Permitir egress a internet (para resolucion DNS, etc)
  security_rule {
    name                       = "AllowInternetOutbound"
    priority                   = 140
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = merge(var.tags, {
    "module" = "app-gateway"
  })
}
# Asociar NSG a la Subnet de App Gateway
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_appgw" {
  subnet_id              = azurerm_subnet.subnet_app_gateway.id
  network_security_group_id = azurerm_network_security_group.nsg_app_gateway.id
}