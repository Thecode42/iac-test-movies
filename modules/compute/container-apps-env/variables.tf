variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, uat, prod)"
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

variable "subnet_apps_id" {
  description = "ID de la subnet de infraestructura del Container Apps Environment"
  type        = string
}
