output "principal_id" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  sensitive = true
}