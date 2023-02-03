resource "azurerm_storage_account" "main" {
    name = var.bucket_name
    resource_group_name = data.azurerm_resource_group.current_resource.name
    location = data.azurerm_resource_group.current_resource.location
    account_tier = "Standard"
    account_replication_type = "LRS"

    network_rules {
      default_action = "Allow"
      ip_rules = [var.allowed_public_ip]
      virtual_network_subnet_ids = [data.azurerm_subnet.current_subnet.id]
    }

    tags = local.common_tags
}

resource "azurerm_storage_container" "main" {
    name = "docker"
    storage_account_name = azurerm_storage_account.main.name
    container_access_type = "private"
}

resource "azurerm_storage_blob" "main" {
    name = "docker-compose.yaml"
    storage_account_name = azurerm_storage_account.main.name
    storage_container_name = azurerm_storage_container.main.name
    type = "Block"
    source = "${dirname(dirname(dirname(abspath(path.root))))}/docker-compose.yaml"
}
