# Move the azure for new resource
resource "azurerm_resource_group" "main" {
  name        = var.resource_group_name
  location    = var.resource_group_location
  tags        = var.tags
}


resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.environment}-k8s"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.environment}-k8s-dns"
  tags = var.tags

  node_resource_group = "dev-k8s-infra"
  automatic_channel_upgrade = "stable"
  http_application_routing_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.main.id 
  }

  identity {
    type = "SystemAssigned"
  }

}
resource "azurerm_role_assignment" "acr" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  scope                            = data.azurerm_container_registry.main.id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}