# # Move the azure for new resource
# resource "azurerm_resource_group" "main" {
#   name        = var.resource_group_name
#   location    = var.resource_group_location
#   tags        = var.tags
# }

# Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = ["10.1.0.0/16"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags = var.tags
}

# Create a Subnet
resource "azurerm_subnet" "cluster" {
  name                 = "${var.environment}-subnet-cluster"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.environment}-k8s"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  dns_prefix          = "${var.environment}-k8s-dns"
  tags = var.tags

  node_resource_group = "${var.resource_group_name}-k8s-infra"
  automatic_channel_upgrade = "stable"
  http_application_routing_enabled = true

  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.main.id
  }


  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.cluster.id
  }

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.ingress.id ]
  }
}

resource "azurerm_role_assignment" "acr" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  scope                            = data.azurerm_container_registry.main.id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}

