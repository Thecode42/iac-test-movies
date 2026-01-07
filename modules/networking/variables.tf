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
