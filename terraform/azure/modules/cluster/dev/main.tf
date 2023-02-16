resource "azurerm_virtual_network" "main" {
    address_space = [ "10.69.0.0/16" ]
    location = data.azurerm_resource_group.main.location
    name = "${var.environment}-networkCluster"
    resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_subnet" "kubesubnet" {
  address_prefixes = [ "10.69.196.0/24" ]
  name = "${var.environment}-subnetNodePool"
  resource_group_name = azurerm_resource_group.rg_new.name
  virtual_network_name = azurerm_virtual_network.main.name
}

resource "azurerm_subnet" "subnet_appgw" {
  name = "${var.environment}-subnetAppgw"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name = data.azurerm_resource_group.main.name
  address_prefixes = [ "10.69.96.0/24" ]
}

resource "azurerm_public_ip" "appgw_publicip" {
  name = "${var.environment}-pubIPAppGW"
  location = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method = "Static"
  sku = "Standard"
  tags = var.tags
}

resource "azurerm_application_gateway" "main" {
  name = "${var.environment}-AppGW"
  resource_group_name = data.azurerm_resource_group.main.name
  location = data.azurerm_resource_group.main.location

  sku {
    name = "${var.environment}-appGWsku"
    tier = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name = "appGWIpconfiguration"
    subnet_id = azurerm_subnet.subnet_appgw.id
  }

  frontend_port {
    name = "appGWFrontendHTTPPort"
    port = 80   
  }

  frontend_port {
    name = "appGWFrontendHTTPsPort"
    port = 443
  }

  frontend_ip_configuration {
    name =  "FrontendIPConfiguration"
    public_ip_address_id = azurerm_public_ip.appgw_publicip.id
  }

  backend_address_pool {
    name = "${var.environment}-backendAddrPool"
  }

  backend_http_settings {
    name = "${var.environment}-backendHttpSettings"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 1
  }

  http_listener {
    name = "${var.environment}-httpListener"
    frontend_ip_configuration_name = "FrontendIPConfiguration"
    frontend_port_name = "appGWFrontendHTTPPort"
    protocol = "Http"
  }

  request_routing_rule {
    name = "${var.environment}-requestRoutingRule"
    rule_type = "Basic"
    http_listener_name = "${var.environment}-httpListener"
    backend_address_pool_name = "${var.environment}-backendAddrPool"
    backend_http_settings_name = "${var.environment}-backendHttpSettings"
  }
}

resource "azurerm_kubernetes_cluster" "main" {
  name = "${var.environment}-Cluster"
  location = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  dns_prefix = "${var.environment}-ClusterDNS"
  http_application_routing_enabled = false
  node_resource_group = "dev-nodeRG"

  default_node_pool {
    name = "devnode"
    node_count = 1
    vm_size = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.kubesubnet.id
  }
  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "192.168.0.69"
    docker_bridge_cidr = "172.16.0.0/16"
    service_cidr = "192.168.0.0/16"
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "role_kubenet" {
  scope = azurerm_subnet.kubesubnet.id
  role_definition_id = "Network Conntributor"
  principal_id = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

