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

variable "subnet_apps_id" {
  description = "ID de la subnet de Container Apps (donde se asocia el NAT)"
  type        = string
}

variable "subnet_nat_prefix" {
  description = "CIDR para subnet NAT Gateway"
  type        = string
  default     = "10.0.4.0/24"
  
  validation {
    condition     = can(regex("^10\\.0\\.[0-9]+\\.0/[0-9]{2}$", var.subnet_nat_prefix))
    error_message = "subnet_nat_prefix debe ser un CIDR valido."
  }
}
