resource "azurerm_user_assigned_identity" "main" {
    location = var.location
    name = "${var.os}-identityforAgent"
    resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "main" {
    scope = var.target_id
    principal_id = azurerm_user_assigned_identity.main.principal_id
    role_definition_name = "Contributor"
}