variable "location" {
  description = "Región principal de Azure"
  type        = string
  default     = "eastus2"
}
variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "uat"
}
variable "waf_mode" {
  description = "Modo WAF: Detection o Prevention"
  type        = string
  default     = "Detection"
}
variable "frontend_image" {
  description = "Imagen del Frontend (Angular + Nginx)"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/aci-helloworld:latest" # Test image - cambiar a ACR cuando esté lista
}

variable "backend_image" {
  description = "Imagen del Backend (.NET 7.0)"
  type        = string
  default     = "mcr.microsoft.com/dotnet/samples:aspnetapp-nanoserver-ltsc2022" # Test - cambiar a ACR
}

variable "backend_environment_variables" {
  description = "Variables de entorno para Backend"
  type        = map(string)
  default = {
    "ASPNETCORE_ENVIRONMENT" = "Development"
  }
}