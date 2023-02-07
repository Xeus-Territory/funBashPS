# Create the virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.environment}-AgentVM"
  computer_name         = var.vmname
  resource_group_name   = data.azurerm_resource_group.main.name
  location              = data.azurerm_resource_group.main.location
  size                  = var.sizedisk
  admin_username        = var.admin_username
  network_interface_ids = [data.azurerm_network_interface.main.id]
  os_disk {
    name                 = "${var.environment}-diskAgentVM"
    caching              = var.caching
    storage_account_type = var.storage_account_type
  }

  admin_ssh_key {
    username   = var.admin_ssh_key
    public_key = data.azurerm_ssh_public_key.main.public_key
  }

  source_image_reference {
    publisher = var.configuration_vm.publisher
    offer     = var.configuration_vm.offer
    sku       = var.configuration_vm.sku
    version   = var.configuration_vm.version
  }

  disable_password_authentication = true

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.main.id]
  }

  user_data = base64encode(templatefile("${abspath(path.module)}/data/userdata.sh",
    {
      user    = var.admin_username,
      url     = var.url_org,
      auth    = var.auth_type,
      token   = var.token,
      pool    = var.pool,
      agent   = var.agent,
      workdir = var.workdir
    }
  ))

  tags = var.tag
}
