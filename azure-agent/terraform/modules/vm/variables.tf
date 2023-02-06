variable "resource_group_name" {
    type = string
    description = "Resource group name of module"
}

variable "environment" {
    type = string
    description = "Environment of module"
}

variable "nicAgent" {
    type = string
    description = "Name of network interface for module"
}

variable "vmname" {
    type = string
    description = "Name of vm for module"
    default = "ReleaseVM"
}

variable "sizedisk" {
    type = string
    description = "Size of disk vm for module"
    default = "Standard_B1s"
}

variable "admin_username" {
    type = string
    description = "admin username for module"
    default = "intern"
}

variable "caching" {
    type = string
    description = "caching style of disk vm for module"
    default = "ReadWrite"
}

variable "storage_account_type" {
    type = string
    description = "storage account type of disk vm for module"
    default = "StandardSSD_LRS"
}

variable "admin_ssh_key" {
    type = string
    description = "admin name for ssh key login for module"
    default = "intern"
    sensitive = true
}

variable "configuration_vm" {
    type = object({
        publisher = string
        offer = string
        sku = string
        version = string
    })
    description = "configuration for type of linux VM"
    default = {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "18.04-LTS"
      version = "latest"
    }
}

variable "user_identity" {
    type = string
    description = "user identity for the identity"
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

variable "workdir" {
    type = string
    description = "work directory for pool"
    default = "usr/local/agent_work"
}