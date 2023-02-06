module "network" {
    source = "../modules/network"
    environment = var.environment
    resource_group_name = var.resource_group_name
    address_prefixes_subnet = [ "10.0.4.0/24" ]
    service_endpoints = [ "Microsoft.Storage" ]
    tag = var.tag
}

module "vm" {
    source = "../modules/vm"
    environment = var.environment
    resource_group_name = var.resource_group_name
    nicAgent = "${var.environment}-nicAgent"
    user_identity = "${var.environment}-identityforVM"
    public_key = var.public_key
    tag = var.tag
    url_org = var.url_org
    token = var.token
    pool = var.pool
    agent = var.agent
    depends_on = [
      module.network
    ]
}