variable "environment" {
    type = string 
    description = "Enviroment name for working"
    default = "dev"
}

variable "tags" {
    type = map
    description = "Resource tags"
    default = {
        managed_by  = "terraform"
        environment = "dev"
    }
}

variable "address_space" {
  type = list(string)
  description = "Address space of Network"
}

variable "address_prefixes" {
  type = list(string)
  description = "Address prefixs of Subnet"  
}

variable "container_registry_name" {
  type = string
  description = "Name of Container Registry"
}

variable "resource_group_location" {
  type = string
  description = "Resource group location of Dev Environment"
  default = "southeastasia"
}

variable "resource_group_root_name" {
  type = string 
  description = "Resource group Root"
}

variable "resource_group_name" {
  type = string
  description = "Resource group name of Dev Environment"
}



# variable "source_image_name" {
#     type = string
# }

# variable "ssh_public_key_name" {
#   type = string
#   description = "Name Public SSH Key"
# }

# variable "blob_name" {
#     type = string 
#     description = "Name of Blob inside a Container of Storage Account"
#     default = "docker-compose.yaml"
# }

# variable "allowed_ips" {
#     type = string
#     description = "Name of Blob inside a Container of Storage Account"
#     sensitive = true
# }


