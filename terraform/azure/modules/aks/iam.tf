
resource "azurerm_user_assigned_identity" "ingress" {
  name                = "ingress-identity"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_role_assignment" "ra1" {
  scope                = azurerm_subnet.cluster.id
  role_definition_name = "Network Contributor"
  # principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
principal_id         = azurerm_user_assigned_identity.ingress.principal_id

  depends_on = [azurerm_virtual_network.main]
}

resource "azurerm_role_assignment" "ra2" {
  scope                = azurerm_application_gateway.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.ingress.principal_id
  depends_on           = [azurerm_user_assigned_identity.ingress, azurerm_application_gateway.main]
}

# resource "azurerm_role_assignment" "ra3" {
#   scope                = data.azurerm_resource_group.main.name
#   role_definition_name = "Reader"
#   principal_id         = azurerm_user_assigned_identity.ingress.principal_id
#   depends_on           = [azurerm_user_assigned_identity.ingress, azurerm_application_gateway.main]
# }

# resource "azurerm_role_assignment" "acr" {
#   principal_id                     = azurerm_user_assigned_identity.ingress.principal_id
#   scope                            = data.azurerm_container_registry.main.id
#   role_definition_name             = "AcrPull"
#   skip_service_principal_aad_check = true
# }

