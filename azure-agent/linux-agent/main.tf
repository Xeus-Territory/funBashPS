resource "azurerm_resource_group" "main" {
  name = "azure-agent"
  location = ""
}


module "iam" {
    source = "../modules/iam"
}

module "network" {
    source = "../modules/network"
    environment = var.environment
    resource_group_name = var.resource_group_name
    address_prefixes_subnet = [ "10.0.4.0/24" ]
    service_endpoints = [ "Microsoft.Storage" ]
    tag = var.tag
    depends_on = [
      module.iam
    ]
}

module "vm" {
    source = "../modules/vm"
    environment = var.environment
    resource_group_name = var.resource_group_name
    nic_id = module.network.nic_id
    user_identity_id = module.iam.user_identity_id
    # user_identity = "${var.environment}-identityforVM"
    public_key = var.public_key
    tag = var.tag
    url_org = var.url_org
    token = var.token
    pool = var.pool
    agent = var.agent
    depends_on = [
      module.network,
      module.iam
    ]
}