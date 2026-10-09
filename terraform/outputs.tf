output "resource_group_name" {
  description = "Provisioned Resource Group."
  value       = azurerm_resource_group.this.name
}

output "acr_name" {
  description = "Provisioned Azure Container Registry."
  value       = azurerm_container_registry.this.name
}

output "acr_login_server" {
  description = "ACR login server. No credentials are output."
  value       = azurerm_container_registry.this.login_server
}

output "container_apps_environment_name" {
  description = "Container Apps Environment name."
  value       = azurerm_container_app_environment.this.name
}

output "container_app_name" {
  description = "Smoke-test Container App name."
  value       = azurerm_container_app.smoke.name
}

output "container_app_fqdn" {
  description = "FQDN if external ingress is enabled; null for an internal-only environment."
  value       = try(azurerm_container_app.smoke.ingress[0].fqdn, null)
}

output "vnet_name" {
  description = "Provisioned Virtual Network."
  value       = azurerm_virtual_network.this.name
}

output "aca_subnet_id" {
  description = "Dedicated subnet ID for the Container Apps Environment."
  value       = azurerm_subnet.aca.id
}

output "managed_identity_client_id" {
  description = "User-assigned managed identity client ID."
  value       = azurerm_user_assigned_identity.aca.client_id
}
