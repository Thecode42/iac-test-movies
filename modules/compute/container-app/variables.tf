variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "container_app_environment_id" {
  description = "ID del Container Apps Environment"
  type        = string
}

variable "container_app_name" {
  description = "Nombre del Container App"
  type        = string
}

variable "container_image" {
  description = "Imagen del container (ej: nginx:alpine o acr.azurecr.io/app:latest)"
  type        = string
}

variable "cpu" {
  description = "CPU (0.25, 0.5, 1, 2)"
  type        = string
  default     = "0.25"
}

variable "memory" {
  description = "Memoria en GB (0.5, 1, 2, 4)"
  type        = string
  default     = "0.5"
}

variable "container_port" {
  description = "Puerto del container"
  type        = number
  default     = 80
}

variable "min_replicas" {
  description = "Minimo de replicas (0 para auto-scale a cero)"
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Maximo de replicas"
  type        = number
  default     = 1
}

variable "environment_variables" {
  description = "Variables de entorno"
  type        = map(string)
  default     = {}
}

variable "expose_publicly" {
  description = "Exponer publicamente (solo Frontend)"
  type        = bool
  default     = false
}

variable "app_type" {
  description = "Tipo de app (frontend o backend)"
  type        = string
  validation {
    condition     = contains(["frontend", "backend"], var.app_type)
    error_message = "app_type debe ser 'frontend' o 'backend'."
  }
}

variable "tags" {
  description = "Tags comunes"
  type        = map(string)
}