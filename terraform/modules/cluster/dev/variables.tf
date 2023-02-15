variable "resource_group_name" {
    type = string
    description = "name of the resource group for the specified resource"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "tags" {
    type = map
    description = "Tag of module"
    default = {
        managed_by = "terraform"
        environment = "dev"
    }
}