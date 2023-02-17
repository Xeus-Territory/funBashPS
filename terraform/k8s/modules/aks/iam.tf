
resource "azurerm_user_assigned_identity" "ingress" {
  name                = "ingress-identity"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_role_assignment" "ra1" {
  scope                = data.azurerm_subnet.kubesubnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id

  depends_on = [azurerm_virtual_network.main]
}

resource "azurerm_role_assignment" "ra2" {
  scope                = azurerm_user_assigned_identity.ingress.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  depends_on           = [azurerm_user_assigned_identity.ingress]
}

resource "azurerm_role_assignment" "ra3" {
  scope                = azurerm_application_gateway.network.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.ingress.principal_id
  depends_on           = [azurerm_user_assigned_identity.ingress, azurerm_application_gateway.network]
}

resource "azurerm_role_assignment" "ra4" {
  scope                = azurerm_resource_group.main.name
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.ingress.principal_id
  depends_on           = [azurerm_user_assigned_identity.ingress, azurerm_application_gateway.network]
}

