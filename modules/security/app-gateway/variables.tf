variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}
variable "location" {
  description = "Region de Azure"
  type        = string
}
variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment debe ser: dev, uat o prod."
  }
}
variable "tags" {
  description = "Tags comunes"
  type        = map(string)
}
variable "vnet_name" {
  description = "Nombre de la VNet existente"
  type        = string
}
variable "subnet_appgw_prefix" {
  description = "CIDR para subnet del App Gateway"
  type        = string
  validation {
    condition     = can(regex("^10\\.0\\.[0-9]+\\.0/[0-9]{2}$", var.subnet_appgw_prefix))
    error_message = "subnet_appgw_prefix debe ser un CIDR valido."
  }
}
variable "container_apps_fqdn" {
  description = "FQDN del Container Apps Environment"
  type        = string
}
variable "container_apps_subnet_prefix" {
  description = "CIDR de la subnet de Container Apps"
  type        = string
}
variable "backend_port" {
  description = "Puerto del backend en Container Apps"
  type        = number
  default     = 80
  validation {
    condition     = var.backend_port >= 1 && var.backend_port <= 65535
    error_message = "backend_port debe estar entre 1 y 65535."
  }
}
variable "health_probe_path" {
  description = "Path para health probe"
  type        = string
  default     = "/"
}
variable "app_gateway_capacity" {
  description = "Capacidad del App Gateway (numero de instancias)"
  type        = number
  default     = 2
  validation {
    condition     = var.app_gateway_capacity >= 1 && var.app_gateway_capacity <= 10
    error_message = "app_gateway_capacity debe estar entre 1 y 10."
  }
}
variable "waf_mode" {
  description = "Modo WAF: Detection o Prevention"
  type        = string
  default     = "Detection"
  validation {
    condition     = contains(["Detection", "Prevention"], var.waf_mode)
    error_message = "waf_mode debe ser 'Detection' o 'Prevention'."
  }
}