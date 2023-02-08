# Create the virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.environment}-vm"
  computer_name         = "${var.environment}vm"
  resource_group_name   = data.azurerm_resource_group.main.name
  location              = data.azurerm_resource_group.main.location
  size                  = "Standard_B1s"
  admin_username        = "intern"
  network_interface_ids = [data.azurerm_network_interface.main.id]
  os_disk {
    name                 = "${var.environment}-disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.main.id]
  }

  admin_ssh_key {
    username   = "intern"
    public_key = data.azurerm_ssh_public_key.main.public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  disable_password_authentication = true
  tags = local.tags
}

resource "azurerm_virtual_machine_extension" "example" {
  name                 = "${var.environment}-vmExtension"
  virtual_machine_id   = azurerm_linux_virtual_machine.main.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
    "script": "${filebase64("${dirname(dirname(dirname(abspath(path.root))))}/script/startup_vm.sh")}"
 }
SETTINGS
}

