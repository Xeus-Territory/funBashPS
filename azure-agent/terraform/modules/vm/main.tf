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
    type = "UserAssigned"
    identity_ids = [ data.azurerm_user_assigned_identity.main.id ]
  }
  tags = var.tag
}

resource "azurerm_virtual_machine_extension" "start_up_script" {
  name = "${var.environment}AgentStartUpScript"
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
    "script": "${base64encode(templatefile("${abspath(path.module)}/data/userdata.sh", { url = var.url_org, auth = var.auth_type, token = var.token, pool = var.pool, agent = var.agent, workdir = var.workdir}))}"
  }
  SETTINGS

  tags = var.tag
}