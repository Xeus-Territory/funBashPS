# Create a VM scale set manutally
resource "azurerm_linux_virtual_machine_scale_set" "main" {
    name = "${local.environment}-vmss"
    resource_group_name = data.azurerm_resource_group.main.name
    location = data.azurerm_resource_group.main.location
    sku = "Standard_B1s"
    instances = 1
    admin_username = "intern"

    admin_ssh_key {
        username = "intern"
        public_key = data.azurerm_ssh_public_key.main.public_key
    }

    os_disk {
        storage_account_type = "StandardSSD_LRS"
        caching = "ReadWrite"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    network_interface {
        name = "${local.environment}-nic"
        primary = true
      ip_configuration {
        name = "internal"
        primary = true
        subnet_id = data.azurerm_subnet.main.id
        load_balancer_backend_address_pool_ids = [ data.azurerm_lb_backend_address_pool.main.id ]
        application_security_group_ids = [ data.azurerm_application_security_group.main.id ]
      }
    }

    disable_password_authentication = true

    identity {
      type = "UserAssigned"
      identity_ids = [ data.azurerm_user_assigned_identity.main.id ]
    }

    lifecycle {
      ignore_changes = [ instances ]
    }

    user_data = "${base64encode(file("${dirname(dirname(abspath(path.root)))}/data/userdata.sh"))}"

    tags = local.common_tags
}

# Set the monitoring for for vmss
resource "azurerm_monitor_autoscale_setting" "main" {
  name = "${local.environment}-AutoscaleSetting"
  resource_group_name = data.azurerm_resource_group.main.name
  location = data.azurerm_resource_group.main.location
  target_resource_id = azurerm_linux_virtual_machine_scale_set.main.id

  profile {
    name = "${local.environment}-defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 2
    }

    rule {
      metric_trigger {
        metric_name = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id
        time_grain = "PT1M"
        statistic = "Average"
        time_window = "PT5M"
        time_aggregation = "Average"
        operator = "GreaterThan"
        threshold = 75
        metric_namespace = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type = "ChangeCount"
        value = 1
        cooldown = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.main.id
        time_grain = "PT1M"
        statistic = "Average"
        time_window = "PT5M"
        time_aggregation = "Average"
        operator = "LessThan"
        threshold = "25"
      }

      scale_action {
        direction = "Decrease"
        type = "ChangeCount"
        value = "1"
        cooldown = "PT1M"
      }
    }
  }

  notification {
    email {
      custom_emails = [ var.email_notification ]
    }
  }
}