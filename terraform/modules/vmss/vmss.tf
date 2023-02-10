
# Create a Linux Virtual Machine Scale sets
resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                  = "${var.environment}-vmss"
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  sku                 = "Standard_B1s"
  instances             = 1
  admin_username        = "intern"

  admin_ssh_key {
    username   = "intern"
    public_key = data.azurerm_ssh_public_key.main.public_key
  }
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.main.id]
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  network_interface {
    name = "${var.environment}-vmss-network"
    primary = true
    ip_configuration {
      name = "internal"
      primary = true
      subnet_id = data.azurerm_subnet.main.id
      load_balancer_backend_address_pool_ids =[ data.azurerm_lb_backend_address_pool.main.id ]
      application_security_group_ids = [ data.azurerm_application_security_group.main.id ] 
    }
  }

  extension {
    name                 = "${var.environment}-vmExtension"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"

    settings = jsonencode({
      "script": "${base64encode("${templatefile("${abspath(path.module)}/data/startup.tpl",{
    "containerRegistry_main" = data.azurerm_container_registry.main.name
    "storageAccount_web" = data.azurerm_storage_account.main.name
    "storageContainer_web" = data.azurerm_storage_container.main.name
    "storageBlob_web" = data.azurerm_storage_blob.main.name
})}")}"
    })
  }

  disable_password_authentication = true
  tags = var.tags
}