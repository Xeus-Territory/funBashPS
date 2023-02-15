resource "azurerm_resource_group" "rg_new"{
  name = "dev-nodeRG"
  location = data.azurerm_resource_group.main.location
}

resource "azurerm_user_assigned_identity" "main" {
    name = "${var.environment}-identityCluster"
    location = var.resource_group_location
    resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "main" {
    scope = data.azurerm_resource_group.root.id
    principal_id = azurerm_user_assigned_identity.main.principal_id
    role_definition_id = data.azurerm_role_definition.main.role_definition_id 
}

resource "azurerm_virtual_network" "main" {
    address_space = [ "10.69.0.0/16" ]
    location = data.azurerm_resource_group.main.location
    name = "${var.environment}-networkCluster"
    resource_group_name = azurerm_resource_group.rg_new.name
}

resource "azurerm_subnet" "main" {
  address_prefixes = [ "10.69.0.0/24" ]
  name = "${var.environment}-subnetCluster"
  resource_group_name = azurerm_resource_group.rg_new.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_kubernetes_cluster" "main" {
  name = "${var.environment}-Cluster"
  location = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  dns_prefix = "${var.environment}-ClusterDNS"
  http_application_routing_enabled = true
  node_resource_group = "dev-nodeRG"

  default_node_pool {
    name = "devnode"
    node_count = 2
    vm_size = "Standard_B2s"
    enable_auto_scaling = false
    enable_host_encryption = false
    enable_node_public_ip = false
  }

  identity {
    type = "UserAssigned"
    identity_ids = [module.iam.identity_cluster]
  }

  tags = var.tags

  depends_on = [
    module.iam
  ]
}