resource "azurerm_role_assignment" "k8s" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  scope                            = var.container_registry_id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
  depends_on = [
    azurerm_kubernetes_cluster.main
  ]
}