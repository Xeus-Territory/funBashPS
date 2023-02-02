resource "azurerm_network_interface" "main" {
    name = "${local.environment}-nicVMSnapShot"
    location = data.azurerm_resource_group.main.location
    resource_group_name = data.azurerm_resource_group.main.name

    ip_configuration {
      name = "${local.environment}-nicVMSnapShotConfiguration"
      subnet_id = data.azurerm_subnet.main.id
      private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_network_interface_application_security_group_association" "main" {
    network_interface_id = azurerm_network_interface.main.id
    application_security_group_id = data.azurerm_application_security_group.main.id
}

resource "azurerm_managed_disk" "main" {
    name = "${local.environment}-snapshotDisk"
    location = data.azurerm_resource_group.main.location
    resource_group_name = data.azurerm_resource_group.main.name
    storage_account_type = "StandardSSD_LRS"
    create_option = "Copy"
    source_resource_id = data.azurerm_managed_disk.main.id
    disk_size_gb = "32"

    tags = local.common_tags
}

resource "azurerm_virtual_machine" "main" {
    name = "${local.environment}-snapshotVM"
    location = data.azurerm_resource_group.main.location
    resource_group_name = data.azurerm_resource_group.main.name
    network_interface_ids = [azurerm_network_interface.main.id]
    vm_size = "Standard_B1s"

    storage_os_disk {
      name = azurerm_managed_disk.main.name
      os_type = azurerm_managed_disk.main.os_type
      managed_disk_id = azurerm_managed_disk.main.id
      create_option = "Attach"
    }

    os_profile_linux_config {
      disable_password_authentication = true
      ssh_keys {
        key_data = data.azurerm_ssh_public_key.main.public_key
        path = "/home/intern/.ssh/authorized_keys"
      }
    }

    identity {
        type = "UserAssigned"
        identity_ids = [ data.azurerm_user_assigned_identity.identity.id ]
    }

    tags = local.common_tags
}