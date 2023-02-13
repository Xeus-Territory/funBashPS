
# Create a load balancer
resource "azurerm_lb" "main" {
  name = "${local.environment}-LoadBalancer"
  location = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  sku = "Standard"

  frontend_ip_configuration {
    name = "${local.environment}-publicIPlbConfiguration"
    public_ip_address_id = azurerm_public_ip.publicip_LB.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-backendlbConfiguration"
}

resource "azurerm_lb_probe" "healthcheckHTTP" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-probeHTTP"
  port = "80"
}

resource "azurerm_lb_probe" "healthcheckHTTPS" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-probeHTTPS"
  port = "443"
}

resource "azurerm_lb_rule" "ruleHTTP" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-LBruleHTTP"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.main.id ]
  frontend_ip_configuration_name = "${local.environment}-publicIPlbConfiguration"
  probe_id = azurerm_lb_probe.healthcheckHTTP.id
  disable_outbound_snat = true
}

resource "azurerm_lb_rule" "ruleHTTPS" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-LBruleHTTPS"
  protocol = "Tcp"
  frontend_port = 443
  backend_port = 443
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.main.id ]
  frontend_ip_configuration_name = "${local.environment}-publicIPlbConfiguration"
  probe_id = azurerm_lb_probe.healthcheckHTTPS.id
  disable_outbound_snat = true
}

resource "azurerm_lb_outbound_rule" "name" {
  name = "${local.environment}-LBOutboundRule"
  loadbalancer_id = azurerm_lb.main.id
  protocol = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id

  frontend_ip_configuration {
      name = "${local.environment}-publicIPlbConfiguration"
  }
}