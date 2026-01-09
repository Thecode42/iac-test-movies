output "nat_gateway_id" {
  description = "ID del NAT Gateway"
  value       = azurerm_nat_gateway.nat_gateway.id
}

output "nat_gateway_name" {
  description = "Nombre del NAT Gateway"
  value       = azurerm_nat_gateway.nat_gateway.name
}

output "nat_public_ip_address" {
  description = "IP publica del NAT Gateway (IP fija para egress)"
  value       = azurerm_public_ip.nat_gateway_pip.ip_address
}

output "nat_public_ip_id" {
  description = "ID de la Public IP del NAT"
  value       = azurerm_public_ip.nat_gateway_pip.id
}

output "nat_subnet_id" {
  description = "ID de la subnet NAT Gateway"
  value       = azurerm_subnet.subnet_nat_gateway.id
}