/* ============================================================================
CONTAINER APP - Container App reutilizable para backend y frontend
============================================================================
* Proposito:
*   Definir un Azure Container App reutilizable para distintos componentes (por ejemplo,
*   frontend y backend) dentro de un mismo Container Apps Environment.
*
Autor: Roger Alcivar
============================================================================
 */
 
# Container App se reutiliza para Frontend y Backend
resource "azurerm_container_app" "app" {
  name                         = var.container_app_name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  # Configuracion de contenedor
  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
    container {
      name   = var.container_app_name
      image  = var.container_image
      cpu    = var.cpu
      memory = var.memory

      # Variables de entorno
      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }

  # Ingress - Exposicion publica que es solo para Frontend
  dynamic "ingress" {
    for_each = var.expose_publicly ? [1] : []
    content {
      allow_insecure_connections = false
      external_enabled           = true
      target_port                = var.container_port

      traffic_weight {
        latest_revision = true
        percentage      = 100
      }
    }
  }

  tags = merge(var.tags, {
    "module" = "container-app"
    "type"   = var.app_type
  })
}
