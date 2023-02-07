variable "resource_group_name" {
    type = string
    description = "Resource group name of module"
}

variable "environment" {
    type = string
    description = "Environment of module"
}

variable "tag" {
    type = map
    description = "Tag of module"
}

variable "address_prefixes_subnet" {
    type = list(string)
    description = "address prefixes subnet of module"
}

variable "service_endpoints" {
    type = list(string)
    description = "service endpoints of module"
}

variable "private_ip_address_allocation" {
  type = string
  description = "type of private IP address"
  default = "Dynamic"
}