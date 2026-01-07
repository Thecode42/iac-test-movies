variable "location" {
  description = "Región principal de Azure"
  type        = string
  default     = "eastus2"
}
variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"
}