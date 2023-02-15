
resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.environment}-k8s"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  dns_prefix          = "${var.environment}-k8s"
  tags = var.tags

  automatic_channel_upgrade = "stable"

  http_application_routing_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    node_network_profile {
      
    }
  }

  node_resource_group = "node"

  identity {
    type = "SystemAssigned"
  }
}