variable "resource_group_name" {
    type = string
    description = "Resource group name of module"
}

variable "location" {
    type = string
    description = "location of resource group"
    default = "southeastasia"
}

variable "environment" {
    type = string
    description = "Environment of module"
}

variable "public_key" {
    type = string
    description = "public key for the identity"
}

variable "tag" {
    type = map
    description = "Tag of module"
}

variable "url_org" {
    type = string
    description = "URL of organization where give access for pool"
    sensitive = true
}

variable "auth_type" {
    type = string
    description = "authentication type for pool"
    default = "pat"
}

variable "token" {
    type = string
    description = "token for the identity"
    sensitive = true
}

variable "pool" {
    type = string
    description = "pool which to create for respresentive"
}

variable "agent" {
    type = string
    description = "agent which to create for respresentive"
}