# resource "azurerm_storage_account" "main" {
#   name                     = "${var.environment}orientdnintern"
#   resource_group_name      = var.resource_group_name
#   location                 = var.resource_group_location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   network_rules {
#       default_action              = "Allow"
#       ip_rules                    = [var.allowed_ips]
#       virtual_network_subnet_ids  = [var.subnet_id]
#   }
#   tags = var.tags
# }

# resource "azurerm_storage_container" "main" {
#   name                  = "${var.environment}-data"
#   storage_account_name  = azurerm_storage_account.main.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_blob" "main" {
#   name                   = "${var.environment}-blob-web"
#   storage_account_name   = azurerm_storage_account.main.name
#   storage_container_name = azurerm_storage_container.main.name
#   type                   = "Block"
#   source                 = "${dirname(dirname(abspath(path.root)))}/${var.blob_name}"
# }

resource "azurerm_storage_share" "main" {
  name                 = "nginx"
  storage_account_name = var.storage_account_name
  quota                = 1
}

resource "azurerm_storage_share_file" "main" {
  name             = "default.conf"
  storage_share_id = azurerm_storage_share.main.id
  source           = "${abspath(path.module)}/data/nginx.conf"
}
