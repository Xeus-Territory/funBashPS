variable "resource_group_name" {
    type = string
}

variable "location" {
    type = string
}

variable "resource_group_id" {
    type = string
}

variable "target_id" {
    type = string
    description = "target resource group for the specified"
}

variable "os" {
    type = string
    description = "os for module"
}