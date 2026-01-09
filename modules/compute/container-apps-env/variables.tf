variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
}

variable "tags" {
  description = "Tags comunes"
  type        = map(string)
}

variable "subnet_apps_id" {
  description = "ID de la subnet de Container Apps"
  type        = string
}
