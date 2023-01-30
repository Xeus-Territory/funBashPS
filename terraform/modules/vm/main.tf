# Create the virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "${local.environment}-VM"
  computer_name         = "ReleaseVM"
  resource_group_name   = data.azurerm_resource_group.current.name
  location              = data.azurerm_resource_group.current.location
  size                  = "Standard_B1s"
  admin_username        = "intern"
  network_interface_ids = [data.azurerm_network_interface.my_terraform_nic.id]
  os_disk {
    name                 = "${local.environment}-disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  admin_ssh_key {
    username   = "intern"
    public_key = data.azurerm_ssh_public_key.my_vm_public_key.public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  disable_password_authentication = true

  identity {
    type = "UserAssigned"
    identity_ids = [ data.azurerm_user_assigned_identity.identity.id ]
  }
  tags = local.common_tags
}

resource "azurerm_virtual_machine_extension" "start_up_script" {
  name = "${local.environment}StartUpScript"
  virtual_machine_id = azurerm_linux_virtual_machine.my_terraform_vm.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
    "script": "${base64encode(file("${abspath(path.root)}/startup.sh"))}"
  }
  SETTINGS

  tags = local.common_tags
}