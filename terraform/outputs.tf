output "acr_name" {
  value = azurerm_container_registry.this_container_registry.name
}

output "acr_url" {
  value = azurerm_container_registry.this_container_registry.login_server
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.this_aks_cluster.name
}

output "azure_service_connection_name" {
  value = azuredevops_serviceendpoint_azurerm.arm_sc.service_endpoint_name
}

output "azure_service_connection_id" {
  value = azuredevops_serviceendpoint_azurerm.arm_sc.id
}
