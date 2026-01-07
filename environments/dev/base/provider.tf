terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  # Aquí configuraremos el backend remoto luego
  backend "azurerm" {}
}

# AQUÍ es donde se configura la conexión
provider "azurerm" {
  features {}
  
  # Si tuvieras una suscripción específica para Dev, iría aquí:
  # subscription_id = "1111-2222-3333-4444" 
}
