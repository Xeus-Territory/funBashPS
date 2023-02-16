data "azurerm_kubernetes_cluster" "main" {
    name = var.clusterName
    resource_group_name = var.clusterRG
}