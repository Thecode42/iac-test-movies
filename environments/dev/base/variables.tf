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
variable "container_apps_fqdn" {
  description = "FQDN del Container Apps Environment"
  type        = string
  default     = "eneroapp-dev.eastus2.azurecontainerapps.io"
}

variable "waf_mode" {
  description = "Modo WAF: Detection o Prevention"
  type        = string
  default     = "Detection"
}