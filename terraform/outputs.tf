output "acr_name" {
  value = azurerm_container_registry.this_container_registry.name
}

output "acr_url" {
  value = azurerm_container_registry.this_container_registry.login_server
}