# Get data_resource from RG
data "azurerm_resource_group" "main" {
  name = "DevOpsIntern"
}

# Get data_resource from sshkey
data "azurerm_ssh_public_key" "main" {
  name = "DevOpsIntern"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_user_assigned_identity" "main" {
  name = "${var.environment}-identity"
  resource_group_name = data.azurerm_resource_group.main.name
}
data "azurerm_network_interface" "main" {
  name = "${var.environment}-nic"
  resource_group_name = data.azurerm_resource_group.main.name
}
