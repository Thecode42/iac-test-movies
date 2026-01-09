variable "resource_group_name" {
    description = "Nombre del resource group"
    type = string 
}
variable "location" {
    description = "Ubicación del recurso"
    type = string
}
variable "vnet_name" { 
    description = "Nombre de la VNet"
    type = string 
}
variable "tags" { 
    description = "Tags para los recursos"
    type = map(string)
}
variable "vnet_address_space" {
  type        = list(string)
  description = "CIDR de toda la VNet"
}
variable "subnet_apps_prefix" {
  type        = string
  description = "CIDR para Apps. MÍNIMO /23 recomendado para Container Apps"
}
variable "subnet_private_prefix" {
  type        = string
  description = "CIDR para Private Endpoints"
}
variable "subnet_aca_env_prefix" {
  type        = string
  description = "CIDR para Container Apps Environment"
}
variable "backend_internal_ports" {
  description = "Puertos internos del Backend (no expuesto a internet)"
  type        = list(number)
  default     = [8080, 5000, 3000]
  
  validation {
    condition     = alltrue([for p in var.backend_internal_ports : p >= 1 && p <= 65535])
    error_message = "Puertos deben estar entre 1 y 65535."
  }
}